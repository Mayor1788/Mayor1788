"""Convierte XML de Oracle WMS Cloud (LgfData) a JSON y a string JSON.

Uso: python3 xml_to_json.py xml/*.xml
Genera en json/:
  <nombre>.json        JSON formateado (legible)
  <nombre>.min.json    JSON compacto en una sola linea
  <nombre>.string.txt  JSON convertido a string (comillas escapadas), listo para pegar
"""
import json
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

# Etiquetas que siempre van como lista, aunque traigan un solo elemento.
FORCE_LIST = {"ib_shipment", "ib_shipment_dtl"}


def to_obj(elem):
    children = list(elem)
    if not children:
        return (elem.text or "").strip()
    obj = {}
    for child in children:
        value = to_obj(child)
        if child.tag in FORCE_LIST:
            obj.setdefault(child.tag, []).append(value)
        elif child.tag in obj:
            if not isinstance(obj[child.tag], list):
                obj[child.tag] = [obj[child.tag]]
            obj[child.tag].append(value)
        else:
            obj[child.tag] = value
    return obj


def main(paths):
    out_dir = Path(__file__).parent / "json"
    out_dir.mkdir(exist_ok=True)
    for path in map(Path, paths):
        root = ET.parse(path).getroot()
        data = {root.tag: to_obj(root)}
        compact = json.dumps(data, ensure_ascii=False, separators=(",", ":"))
        (out_dir / f"{path.stem}.json").write_text(
            json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        (out_dir / f"{path.stem}.min.json").write_text(compact, encoding="utf-8")
        (out_dir / f"{path.stem}.string.txt").write_text(
            json.dumps(compact, ensure_ascii=False), encoding="utf-8")
        print(f"{path.name}: {len(compact):,} caracteres")


if __name__ == "__main__":
    main(sys.argv[1:])
