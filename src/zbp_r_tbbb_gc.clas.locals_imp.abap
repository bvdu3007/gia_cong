CLASS lsc_zr_tbbb_gc DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zr_tbbb_gc IMPLEMENTATION.

  METHOD save_modified.
    DATA : lt_bb_gc    TYPE STANDARD TABLE OF ztb_bb_gc,
           ls_bb_gc    TYPE                   ztb_bb_gc,
           ls_bb_gc_db TYPE                   ztb_bb_gc,
           ls_bb_gc_ud TYPE                   ztb_bb_gc.

    DATA : lt_gc_loi TYPE STANDARD TABLE OF ztb_gc_loi,
           ls_gc_loi TYPE                   ztb_gc_loi.
    DATA: lw_field_name TYPE char72.

    TYPES: BEGIN OF ty_mapping,
             field_ent TYPE string,
             field_db  TYPE string,
           END OF ty_mapping.

    DATA: gt_mapping TYPE STANDARD TABLE OF ty_mapping WITH DEFAULT KEY.

    "Insert các cặp mapping
    APPEND VALUE #( field_ent = 'HdrID'         field_db = 'hdr_id' )         TO gt_mapping.
    APPEND VALUE #( field_ent = 'LoaiHang'      field_db = 'loai_hang' )     TO gt_mapping.
    APPEND VALUE #( field_ent = 'SoBb'          field_db = 'so_bb' )         TO gt_mapping.
    APPEND VALUE #( field_ent = 'SoBbNum'       field_db = 'so_bb_num' )     TO gt_mapping.
    APPEND VALUE #( field_ent = 'SoBbSub'       field_db = 'so_bb_sub' )     TO gt_mapping.
    APPEND VALUE #( field_ent = 'NgayLapBb'     field_db = 'ngay_lap_bb' )   TO gt_mapping.
    APPEND VALUE #( field_ent = 'SoPo'          field_db = 'so_po' )         TO gt_mapping.
    APPEND VALUE #( field_ent = 'NgayNhapHang'  field_db = 'ngay_nhap_hang') TO gt_mapping.
    APPEND VALUE #( field_ent = 'NgayTraBb'     field_db = 'ngay_tra_bb' )   TO gt_mapping.
    APPEND VALUE #( field_ent = 'NgayNhapKho'   field_db = 'ngay_nhap_kho' ) TO gt_mapping.
    APPEND VALUE #( field_ent = 'GhiChu'        field_db = 'ghi_chu' )       TO gt_mapping.
    APPEND VALUE #( field_ent = 'CreatedBy'     field_db = 'created_by' )    TO gt_mapping.
    APPEND VALUE #( field_ent = 'CreatedAt'     field_db = 'created_at' )    TO gt_mapping.
    APPEND VALUE #( field_ent = 'LastChangedBy' field_db = 'last_changed_by') TO gt_mapping.
    APPEND VALUE #( field_ent = 'LastChangedAt' field_db = 'last_changed_at') TO gt_mapping.
    LOOP AT gt_mapping ASSIGNING FIELD-SYMBOL(<fs_mapping>).
      TRANSLATE <fs_mapping>-field_ent TO UPPER CASE.
      TRANSLATE <fs_mapping>-field_db TO UPPER CASE.
    ENDLOOP.
    DATA: gt_mapping_loi TYPE STANDARD TABLE OF ty_mapping WITH DEFAULT KEY.

    "Insert các cặp mapping
    APPEND VALUE #( field_ent = 'HdrID'         field_db = 'hdr_id' )         TO gt_mapping_loi.
    APPEND VALUE #( field_ent = 'DtlID'         field_db = 'dtl_id' )         TO gt_mapping_loi.
    APPEND VALUE #( field_ent = 'LoaiHang'      field_db = 'loai_hang' )      TO gt_mapping_loi.
    APPEND VALUE #( field_ent = 'LoaiLoi'       field_db = 'loai_loi' )       TO gt_mapping_loi.
    APPEND VALUE #( field_ent = 'ErrorCode'     field_db = 'error_code' )     TO gt_mapping_loi.
    APPEND VALUE #( field_ent = 'SlLoi'         field_db = 'sl_loi' )         TO gt_mapping_loi.
    APPEND VALUE #( field_ent = 'CheckBangi'    field_db = 'check_bangi' )    TO gt_mapping_loi.
    APPEND VALUE #( field_ent = 'CheckBangii'   field_db = 'check_bangii' )   TO gt_mapping_loi.
    APPEND VALUE #( field_ent = 'GhiChu'        field_db = 'ghi_chu' )        TO gt_mapping_loi.
    APPEND VALUE #( field_ent = 'CreatedBy'     field_db = 'created_by' )     TO gt_mapping_loi.
    APPEND VALUE #( field_ent = 'CreatedAt'     field_db = 'created_at' )     TO gt_mapping_loi.
    APPEND VALUE #( field_ent = 'LastChangedBy' field_db = 'last_changed_by') TO gt_mapping_loi.
    APPEND VALUE #( field_ent = 'LastChangedAt' field_db = 'last_changed_at') TO gt_mapping_loi.

    LOOP AT gt_mapping_loi ASSIGNING  <fs_mapping>.
      TRANSLATE <fs_mapping>-field_ent TO UPPER CASE.
      TRANSLATE <fs_mapping>-field_db TO UPPER CASE.
    ENDLOOP.

    IF create-zrtbbbgc IS NOT INITIAL.
      lt_bb_gc = CORRESPONDING #( create-zrtbbbgc MAPPING FROM ENTITY ).
      INSERT ztb_bb_gc FROM TABLE @lt_bb_gc.
    ENDIF.

    LOOP AT delete-zrtbbbgc INTO DATA(ls_detele) WHERE HdrID IS NOT INITIAL.
      DELETE FROM ztb_bb_gc WHERE hdr_id = @ls_detele-HdrID.
    ENDLOOP.

    IF create-zrtbgcloi IS NOT INITIAL.
      lt_gc_loi = CORRESPONDING #( create-zrtbgcloi MAPPING FROM ENTITY ).
      INSERT ztb_gc_loi FROM TABLE @lt_gc_loi.
    ENDIF.

    LOOP AT delete-zrtbgcloi INTO DATA(ls_detele_dtl) WHERE HdrID IS NOT INITIAL AND DtlID IS NOT INITIAL.
      DELETE FROM ztb_gc_loi WHERE hdr_id = @ls_detele_dtl-HdrID AND dtl_id = @ls_detele_dtl-DtlID.
    ENDLOOP.

    IF update-zrtbbbgc IS NOT INITIAL OR update-zrtbgcloi IS NOT INITIAL.
      CLEAR lt_bb_gc.
      CLEAR lt_gc_loi.
      lt_gc_loi = CORRESPONDING #( update-zrtbgcloi MAPPING FROM ENTITY ).
      lt_bb_gc = CORRESPONDING #( update-zrtbbbgc MAPPING FROM ENTITY ).
      IF lt_bb_gc IS NOT INITIAL.
        READ TABLE lt_bb_gc INDEX 1 INTO ls_bb_gc_ud.
        SELECT SINGLE * FROM ztb_bb_gc
           WHERE hdr_id = @ls_bb_gc_ud-hdr_id
           INTO @ls_bb_gc .
      ELSE.
        READ TABLE lt_gc_loi INDEX 1 INTO ls_gc_loi.
        SELECT SINGLE * FROM ztb_bb_gc
            WHERE hdr_id = @ls_gc_loi-hdr_id
            INTO @ls_bb_gc .
      ENDIF.

      DATA update_struct TYPE REF TO cl_abap_structdescr.
      IF update-zrtbbbgc IS NOT INITIAL.
        READ TABLE update-zrtbbbgc INDEX 1 INTO DATA(ls_update_zrtbbbgc).

        update_struct ?= cl_abap_structdescr=>describe_by_data( ls_update_zrtbbbgc-%control ).

        LOOP AT update_struct->components INTO DATA(field).

          IF ls_update_zrtbbbgc-%control-(field-name) = if_abap_behv=>mk-on.
            READ TABLE gt_mapping ASSIGNING <fs_mapping>
                WITH KEY field_ent = field-name.
            IF sy-subrc IS INITIAL.
              lw_field_name = <fs_mapping>-field_db.
            ELSE.
              lw_field_name = field-name.
            ENDIF.
            ls_bb_gc-(lw_field_name) = ls_update_zrtbbbgc-(field-name).
          ENDIF.
        ENDLOOP.

        FREE update_struct.
      ENDIF.

      SELECT * FROM ztb_gc_loi
          WHERE hdr_id = @ls_bb_gc-hdr_id
          INTO TABLE @lt_gc_loi.

      IF update-zrtbgcloi IS NOT INITIAL.
        READ TABLE update-zrtbgcloi INDEX 1 INTO DATA(ls_update_zrtbgcloi).
        update_struct ?= cl_abap_structdescr=>describe_by_data( ls_update_zrtbgcloi-%control ).
        LOOP AT update-zrtbgcloi INTO ls_update_zrtbgcloi.
          READ TABLE lt_gc_loi ASSIGNING FIELD-SYMBOL(<lf_gc_loi>)
              WITH KEY hdr_id = ls_update_zrtbgcloi-HdrID dtl_id = ls_update_zrtbgcloi-DtlID.
          IF sy-subrc IS INITIAL.
            LOOP AT update_struct->components INTO field.
              IF ls_update_zrtbgcloi-%control-(field-name) = if_abap_behv=>mk-on.
                READ TABLE gt_mapping_loi ASSIGNING <fs_mapping>
                  WITH KEY field_ent = field-name.
                IF sy-subrc IS INITIAL.
                  lw_field_name = <fs_mapping>-field_db.
                ELSE.
                  lw_field_name = field-name.
                ENDIF.
                <lf_gc_loi>-(lw_field_name) = ls_update_zrtbgcloi-(field-name).
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDLOOP.
      ENDIF.

      CLEAR: ls_bb_gc-ct14, ls_bb_gc-Ct14,  ls_bb_gc-Ct18,  ls_bb_gc-Ct19,  ls_bb_gc-Ct20,  ls_bb_gc-Ct21,  ls_bb_gc-Ct22,
             ls_bb_gc-Ct24,  ls_bb_gc-Ct25,  ls_bb_gc-Ct26,  ls_bb_gc-Ct27,  ls_bb_gc-Ct28,  ls_bb_gc-Ct29,  ls_bb_gc-Ct30,
             ls_bb_gc-Ct31,  ls_bb_gc-Ct32,  ls_bb_gc-Ct40,  ls_bb_gc-Ct47,  ls_bb_gc-Ct48.
      LOOP AT lt_gc_loi ASSIGNING <lf_gc_loi>.
        CLEAR: <lf_gc_loi>-tile, <lf_gc_loi>-check_bangi, <lf_gc_loi>-check_bangii.
        IF ls_bb_gc-ct13 <> 0.
          <lf_gc_loi>-tile = <lf_gc_loi>-sl_loi / ls_bb_gc-ct13 * 100.
        ENDIF.

        IF <lf_gc_loi>-tile > <lf_gc_loi>-bangi .
          <lf_gc_loi>-check_bangi = 'V'.
        ENDIF.

        IF <lf_gc_loi>-tile > <lf_gc_loi>-bangii .
          <lf_gc_loi>-check_bangii = 'V'.
        ENDIF.

        IF <lf_gc_loi>-loai_loi = 'C'.
          ls_bb_gc-ct25 = ls_bb_gc-ct25 + <lf_gc_loi>-sl_loi.
        ENDIF.

        IF <lf_gc_loi>-check_bangi = 'V'.
          ls_bb_gc-ct27 = ls_bb_gc-ct27 + 1.
        ENDIF.

        IF <lf_gc_loi>-check_bangii = 'V' AND <lf_gc_loi>-loai_loi = 'B'.
          ls_bb_gc-ct29 = ls_bb_gc-ct29 + 1.
        ENDIF.

        IF <lf_gc_loi>-check_bangii = 'V' AND <lf_gc_loi>-loai_loi = 'A'.
          ls_bb_gc-ct31 = ls_bb_gc-ct31 + 1.
        ENDIF.

      ENDLOOP.

      ls_bb_gc-ct24 = ls_bb_gc-ct13 - ls_bb_gc-ct27 - ls_bb_gc-ct25 .
      IF ls_bb_gc-ct12 IS NOT INITIAL.
        ls_bb_gc-ct14 = ls_bb_gc-ct13 / ls_bb_gc-ct12 .
      ENDIF.


      IF ls_bb_gc-ct13 IS NOT INITIAL.
        ls_bb_gc-ct26 = ls_bb_gc-ct25 / ls_bb_gc-ct13 .
        ls_bb_gc-ct28 = ls_bb_gc-ct27 / ls_bb_gc-ct13 .
        ls_bb_gc-ct30 = ls_bb_gc-ct29 / ls_bb_gc-ct13 .
        ls_bb_gc-ct32 = ls_bb_gc-ct31 / ls_bb_gc-ct13 .
      ENDIF.

      IF ls_bb_gc-ct26 > 10.
        ls_bb_gc-ct22 =  (  ls_bb_gc-ct26 - 10 ) * ls_bb_gc-ct23.
      ENDIF.

      ls_bb_gc-ct19 = ls_bb_gc-ct23 * ls_bb_gc-ct28.
      ls_bb_gc-ct20 = ls_bb_gc-ct23 * ls_bb_gc-ct30.
      ls_bb_gc-ct21 = ls_bb_gc-ct23 * ls_bb_gc-ct32.

      ls_bb_gc-ct18 = ls_bb_gc-ct23 - ls_bb_gc-ct19 - ls_bb_gc-ct22.

      ls_bb_gc-ct40 = ls_bb_gc-ct33 + ls_bb_gc-ct34 + ls_bb_gc-ct35 + ls_bb_gc-ct36 +
                       ls_bb_gc-ct37 + ls_bb_gc-ct38 + ls_bb_gc-ct39.

      ls_bb_gc-ct47 = ls_bb_gc-ct41 + ls_bb_gc-ct42 + ls_bb_gc-ct43 + ls_bb_gc-ct44 +
                       ls_bb_gc-ct45 + ls_bb_gc-ct46 .

      ls_bb_gc-ct48 = ls_bb_gc-ct40 + ls_bb_gc-ct47.

      MODIFY ztb_bb_gc FROM @ls_bb_gc.
      MODIFY ztb_gc_loi FROM TABLE @lt_gc_loi.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zr_tbbb_gc DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ZrTbbbGc
        RESULT result,
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR ZrTbbbGc RESULT result,
      SetData_GC FOR DETERMINE ON SAVE
        IMPORTING keys FOR ZrTbbbGc~SetData_GC.
ENDCLASS.

CLASS lhc_zr_tbbb_gc IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD get_instance_features.
  ENDMETHOD.

  METHOD SetData_GC.
    DATA: lt_dtl TYPE TABLE FOR CREATE zr_tbbb_gc\_dtl,
          ls_dtl TYPE STRUCTURE FOR CREATE zr_tbbb_gc\_dtl.
    DATA: lw_so_bb_num TYPE  ztb_bb_gc-so_bb_num,
          lw_so_bb_sub TYPE  ztb_bb_gc-so_bb_sub,
          lw_so_bb     TYPE  ztb_bb_gc-so_bb.

    "Read travel instances of the transferred keys
    READ ENTITIES OF zr_tbbb_gc IN LOCAL MODE
     ENTITY ZrTbbbGc
       FIELDS ( SoBb )
       WITH CORRESPONDING #( keys )
     RESULT DATA(GiaCong_data)
     FAILED DATA(read_failed).

    READ TABLE keys INTO DATA(ls_key) INDEX 1.
    READ TABLE GiaCong_data INTO DATA(ls_gia_cong) INDEX 1.
    CHECK sy-subrc IS INITIAL.

    SELECT so_bb_num, MAX( so_bb_sub ) AS so_bb_sub FROM ztb_bb_gc
    WHERE loai_hang = @ls_gia_cong-LoaiHang AND so_po = @ls_gia_cong-SoPo
     GROUP BY so_bb_num
     INTO TABLE @DATA(lt_so_bb_sub).
    IF sy-subrc IS INITIAL.
      READ TABLE lt_so_bb_sub INDEX 1 INTO DATA(ls_so_bb_sub).
      lw_so_bb_sub = ls_so_bb_sub-so_bb_sub + 1.
      lw_so_bb_num = ls_so_bb_sub-so_bb_num.
    ELSE.
      SELECT MAX( so_bb_num ) FROM ztb_bb_gc
          WHERE loai_hang = @ls_gia_cong-LoaiHang AND substring( ngay_lap_bb, 1, 6 ) = @ls_gia_cong-NgayLapBb(6)
           INTO @lw_so_bb_num.
      lw_so_bb_num = lw_so_bb_num + 1.
    ENDIF.

    IF ls_gia_cong-LoaiHang = '1'.
      lw_so_bb = 'HO_' .
    ELSE.
      lw_so_bb = 'HV_'.
    ENDIF.
    lw_so_bb = lw_so_bb && ls_gia_cong-NgayLapBb+2(2) && '/'  && ls_gia_cong-NgayLapBb+2(2)  && lw_so_bb_num.
    IF lw_so_bb_sub IS NOT INITIAL.
      lw_so_bb = lw_so_bb && '_' && lw_so_bb_sub.
    ENDIF.

    "else set overall travel status to open ('O')
    MODIFY ENTITIES OF zr_tbbb_gc IN LOCAL MODE
      ENTITY ZrTbbbGc
        UPDATE FIELDS ( SoBb SoBbNum SoBbSub )
        WITH VALUE #(
          ( %tky = ls_gia_cong-%tky
            SoBb = lw_so_bb
            SoBbNum = lw_so_bb_num
            SoBbSub = lw_so_bb_sub )
        ).

    SELECT * FROM ztb_loi_h_dtl
    WHERE loai_hang = @ls_gia_cong-LoaiHang
    INTO TABLE @DATA(lt_loi).

    LOOP AT lt_loi INTO DATA(ls_loi).
      ls_dtl-HdrID = ls_key-HdrID.
      ls_dtl-%target =  VALUE #(  ( %cid = 'Dtl' && sy-tabix
                                                    LoaiLoi = ls_loi-loai_loi
                                                    LoaiHang = ls_loi-loai_hang
                                                    ErrorCode = ls_loi-error_code
                                                    Errordesc = ls_loi-errordesc
                                                    Bangi = ls_loi-bangi
                                                    Bangii = ls_loi-bangii
                                                    ) ) .
      APPEND ls_dtl TO lt_dtl.
    ENDLOOP.

    "else set overall travel status to open ('O')
    MODIFY ENTITIES OF zr_tbbb_gc IN LOCAL MODE
     ENTITY ZrTbbbGc
       CREATE BY \_dtl
            FIELDS ( LoaiLoi LoaiHang ErrorCode Errordesc Bangi Bangii )
               WITH lt_dtl
               REPORTED DATA(update_reported1).
  ENDMETHOD.

*
*  METHOD Calculate_data.
**    DATA: lt_dtl TYPE TABLE FOR UPDATE zr_tbbb_gc,
**          ls_dtl TYPE STRUCTURE FOR UPDATE zr_tbbb_gc\_dtl.
*
**    READ ENTITIES OF zr_tbbb_gc IN LOCAL MODE
**   ENTITY ZrTbgcLoi
**     ALL FIELDS WITH
**     CORRESPONDING #( keys )
**   RESULT DATA(lt_loi)
**   FAILED DATA(read_failed).
**
**    READ TABLE lt_loi INDEX 1 INTO DATA(ls_loi).
**    READ TABLE keys INDEX 1 INTO DATA(ls_key).
***    LOOP AT lt_loi INTO DATA(ls_loi).
***      ls_dtl-HdrID = ls_key-HdrID.
***      ls_dtl-%target =  VALUE #(  ( %key = ls_loi-%key
***                                                    LoaiLoi = ls_loi-LoaiLoi
***                                                    LoaiHang = ls_loi-LoaiHang
***                                                    CheckBangi = 'V'
***                                                    CheckBangii = 'V'
***                                                    ) ) .
***      APPEND ls_dtl TO lt_dtl.
***    ENDLOOP.
**
**    "else set overall travel status to open ('O')
**    MODIFY ENTITIES OF zr_tbbb_gc IN LOCAL MODE
**     ENTITY ZrTbgcLoi
**       UPDATE
**            FIELDS ( CheckBangi CheckBangii )
**                WITH VALUE #(
**          ( %tky = ls_loi-%tky
**            CheckBangi = 'V'
**            CheckBangii = 'V' )
**        ).
*
* "Read travel instances of the transferred keys
*    READ ENTITIES OF zr_tbbb_gc IN LOCAL MODE
*     ENTITY ZrTbbbGc
*       FIELDS ( SoBb )
*       WITH CORRESPONDING #( keys )
*     RESULT DATA(GiaCong_data).
*
*    READ TABLE keys INTO DATA(ls_key1) INDEX 1.
*    READ TABLE GiaCong_data INTO DATA(ls_gia_cong) INDEX 1.
*    CHECK sy-subrc IS INITIAL.
*
*        "else set overall travel status to open ('O')
*    MODIFY ENTITIES OF zr_tbbb_gc IN LOCAL MODE
*      ENTITY ZrTbbbGc
*        UPDATE FIELDS ( SoBb )
*        WITH VALUE #(
*          ( %tky = ls_gia_cong-%tky
*            SoBb = 'ABCD' )
*        ).
*
*
*
*  ENDMETHOD.

ENDCLASS.
