SET DEFINE OFF
SET SERVEROUTPUT ON
VARIABLE rid VARCHAR2(30)

BEGIN
  INSERT INTO SHIPMENT_VERIFICATION_HDR (ID, STATUS, COLUMNA_JSON)
  VALUES ('112321343242', 'PENDIENTE', EMPTY_CLOB())
  RETURNING ROWIDTOCHAR(ROWID) INTO :rid;
END;
/

DECLARE
  l CLOB;
  PROCEDURE a(s VARCHAR2) IS BEGIN DBMS_LOB.WRITEAPPEND(l, LENGTH(s), s); END;
BEGIN
  SELECT COLUMNA_JSON INTO l FROM SHIPMENT_VERIFICATION_HDR
   WHERE ROWID = CHARTOROWID(:rid) FOR UPDATE;
  a(q'~{"LgfData":{"Header":{"DocumentVersion":"26B","OriginSystem":"LogFire","ClientEnvCode":"diunsa","ParentCompanyCode":"*","Entity":"shipment_verification","TimeStamp":"2026-09-16T08:59:41","MessageId":"SVSFILE000874945"},"ListOfVerifiedIbShipments":{"ib_shipment":[{"ib_shipment_hdr":{"shipment_nbr":"EC01080141-078691","facility_code":"CD","company_code":"DIUNSA","trailer_nbr":"SMLU7965527","ref_nbr":"OC01088348","shipment_type":"IMP","load_nbr":"LEC01080141-078691","manifest_nbr":"","trailer_type":"","vendor_info":"7204212786 7204212787 7204212788 7204212789 7204212790 7204212791 7204212792 7204212856","origin_info":"","origin_code":"","orig_shipped_units":"9","shipped_date":"2026-08-27","orig_shipped_lpns":"0","shipment_hdr_cust_field_1":"","shipment_hdr_cust_field_2":"","shipment_hdr_cust_field_3":"","shipment_hdr_cust_field_4":"","shipment_hdr_cust_field_5":"","verification_date":"2026-09-16","returned_from_facility_code":"","shipment_hdr_cust_date_1":"","shipment_hdr_cust_date_2":"","shipment_hdr_cust_date_3":"","shipment_hdr_cust_date_4":"","shipment_hdr_cust_date_5":"","shipment_hdr_cust_decimal_1":"","shipment_hdr_cust_decimal_2":"","shipment_hdr_cust_decimal_3":"","shipment_hdr_cust_decimal_4":"","shipment_hdr_cust_decimal_5":"","shipment_hdr_cust_number_1":"","shipment_hdr_cust_number_2":"","shipment_hdr_cust_number_3":"","shipment_hdr_cust_number_4":"","shipment_hdr_cust_number_5":"","shipment_hdr_cust_long_text_1":"","shipment_hdr_cust_long_text_2":"","shipment_hdr_cust_long_text_3":"","shipment_hdr_cust_short_text_1":"","shipment_hdr_cust_short_text_2":"","shipment_hdr_cust_short_text_3":"","shipment_hdr_cust_short_text_4":"","shipment_hdr_cust_short_text_5":"","shipment_hdr_cust_short_text_6":"","shipment_hdr_cust_short_text_7":"","shipment_hdr_cust_short_text_8":"","shipment_hdr_cust_short_text_9":"","shipment_hdr_cust_short_text_10":"","shipment_hdr_cust_short_text_11":"","shipment_hdr_cust_short_text_12":""},"ib_shipment_dtl":[{"seq_nbr":"859504","lpn_~');
  a(q'~nbr":"PL02283912","lpn_weight":"0.45","lpn_volume":"67320","item_alternate_code":"4069987569623","item_part_a":"4069987569623","item_part_b":"","item_part_c":"","item_part_d":"","item_part_e":"","item_part_f":"","pre_pack_code":"","pre_pack_ratio":"0","pre_pack_ratio_seq":"0","pre_pack_total_units":"0","invn_attr_a":"","invn_attr_b":"","invn_attr_c":"","shipped_qty":"9","priority_date":"","po_nbr":"OC01088348","pallet_nbr":"","putaway_type":"1596","received_qty":"9","expiry_date":"","batch_nbr":"","recv_xdock_facility_code":"","shipment_dtl_cust_field_1":"","shipment_dtl_cust_field_2":"","shipment_dtl_cust_field_3":"","shipment_dtl_cust_field_4":"","shipment_dtl_cust_field_5":"","lpn_is_physical_pallet_flg":"true","po_seq_nbr":"840941","lock_code":"","serial_nbr":"","invn_attr_d":"","invn_attr_e":"","invn_attr_f":"","invn_attr_g":"","rcvd_trailer_nbr":"SMLU7965527","po_dtl_line_schedule_nbrs":"","ref_order_nbr":"","ref_order_seq_nbr":"","invn_attr_h":"","invn_attr_i":"","invn_attr_j":"","invn_attr_k":"","invn_attr_l":"","invn_attr_m":"","invn_attr_n":"","invn_attr_o":"","inventory_lock_code":"","erp_bucket":"","shipment_dtl_cust_date_1":"","shipment_dtl_cust_date_2":"","shipment_dtl_cust_date_3":"","shipment_dtl_cust_date_4":"","shipment_dtl_cust_date_5":"","shipment_dtl_cust_decimal_1":"","shipment_dtl_cust_decimal_2":"","shipment_dtl_cust_decimal_3":"","shipment_dtl_cust_decimal_4":"","shipment_dtl_cust_decimal_5":"","shipment_dtl_cust_number_1":"","shipment_dtl_cust_number_2":"","shipment_dtl_cust_number_3":"","shipment_dtl_cust_number_4":"","shipment_dtl_cust_number_5":"","shipment_dtl_cust_long_text_1":"","shipment_dtl_cust_long_text_2":"","shipment_dtl_cust_long_text_3":"","shipment_dtl_cust_short_text_1":"","shipment_dtl_cust_short_text_2":"","shipment_dtl_cust_short_text_3":"","shipment_dtl_cust_short_text_4":"","shipment_dtl_cust_short_text_5":"","shipment_dtl_cust_short_text_6":"","shipment_dtl_cust_short_text_7":"","shipment_dtl_cust_short_text_8":"","shi~');
  a(q'~pment_dtl_cust_short_text_9":"","shipment_dtl_cust_short_text_10":"","shipment_dtl_cust_short_text_11":"","shipment_dtl_cust_short_text_12":""}]}]}}}~');
END;
/

DECLARE
  n NUMBER;
BEGIN
  SELECT DBMS_LOB.GETLENGTH(COLUMNA_JSON) INTO n FROM SHIPMENT_VERIFICATION_HDR
   WHERE ROWID = CHARTOROWID(:rid);
  IF n <> 4149 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Largo incorrecto: ' || n || ' <> 4149');
  END IF;
  DBMS_OUTPUT.PUT_LINE('OK, caracteres cargados: ' || n);
END;
/

COMMIT;
