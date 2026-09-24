"""Genera scripts .sql para insertar el JSON (CLOB) en SHIPMENT_VERIFICATION_HDR.

Uso: python3 json_to_sql.py [--column NOMBRE_COLUMNA] [--id-column ID --id VALOR] [--status PENDIENTE] json/X.min.json
Genera sql/<nombre>.sql. Ejecutar como script (SQL*Plus / SQL Developer F5).

El JSON se carga por partes: primero se inserta la fila con EMPTY_CLOB() y
luego varios bloques PL/SQL chicos le van agregando trozos, para no pasar el
limite de 4000 bytes de un literal SQL ni el de tamano de un bloque PL/SQL.
"""
import argparse
from pathlib import Path

TABLE = "SHIPMENT_VERIFICATION_HDR"
CHUNK = 2000          # caracteres por literal (lineas cortas para SQL*Plus)
CHUNKS_PER_BLOCK = 50  # ~100 KB por bloque PL/SQL


def build(json_text, column, extra):
    for i in range(0, len(json_text), CHUNK):
        if "~'" in json_text[i:i + CHUNK + 1]:
            raise ValueError("el JSON contiene ~' y rompe el q-quote")
    chunks = [json_text[i:i + CHUNK] for i in range(0, len(json_text), CHUNK)]
    out = [
        "SET DEFINE OFF",
        "SET SERVEROUTPUT ON",
        "VARIABLE rid VARCHAR2(30)",
        "",
        "BEGIN",
    ]
    # Valores entre comillas para no perder ceros a la izquierda (Oracle convierte si la columna es NUMBER).
    cols = [*extra, column]
    vals = [f"'{v}'" for v in extra.values()] + ["EMPTY_CLOB()"]
    out += [f"  INSERT INTO {TABLE} ({', '.join(cols)})",
            f"  VALUES ({', '.join(vals)})"]
    out += [
        "  RETURNING ROWIDTOCHAR(ROWID) INTO :rid;",
        "END;",
        "/",
        "",
    ]
    for b in range(0, len(chunks), CHUNKS_PER_BLOCK):
        out += [
            "DECLARE",
            "  l CLOB;",
            "  PROCEDURE a(s VARCHAR2) IS BEGIN DBMS_LOB.WRITEAPPEND(l, LENGTH(s), s); END;",
            "BEGIN",
            f"  SELECT {column} INTO l FROM {TABLE}",
            "   WHERE ROWID = CHARTOROWID(:rid) FOR UPDATE;",
        ]
        out += [f"  a(q'~{c}~');" for c in chunks[b:b + CHUNKS_PER_BLOCK]]
        out += ["END;", "/", ""]
    out += [
        "DECLARE",
        "  n NUMBER;",
        "BEGIN",
        f"  SELECT DBMS_LOB.GETLENGTH({column}) INTO n FROM {TABLE}",
        "   WHERE ROWID = CHARTOROWID(:rid);",
        f"  IF n <> {len(json_text)} THEN",
        f"    RAISE_APPLICATION_ERROR(-20001, 'Largo incorrecto: ' || n || ' <> {len(json_text)}');",
        "  END IF;",
        "  DBMS_OUTPUT.PUT_LINE('OK, caracteres cargados: ' || n);",
        "END;",
        "/",
        "",
        "COMMIT;",
        "",
    ]
    return "\n".join(out)


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--column", default="COLUMNA_JSON")
    p.add_argument("--id-column", default="ID")
    p.add_argument("--id", help="valor del ID (solo con un archivo)")
    p.add_argument("--status-column", default="STATUS")
    p.add_argument("--status", default="PENDIENTE")
    p.add_argument("files", nargs="+")
    args = p.parse_args()
    if args.id is not None and len(args.files) != 1:
        p.error("--id se usa con un solo archivo")
    out_dir = Path(__file__).parent / "sql"
    out_dir.mkdir(exist_ok=True)
    extra = {}
    if args.id is not None:
        extra[args.id_column] = args.id
    if args.status:
        extra[args.status_column] = args.status
    for path in map(Path, args.files):
        name = path.name.removesuffix(".min.json")
        sql = build(path.read_text(encoding="utf-8"), args.column, extra)
        (out_dir / f"{name}.sql").write_text(sql, encoding="utf-8")
        print(f"sql/{name}.sql")


if __name__ == "__main__":
    main()
