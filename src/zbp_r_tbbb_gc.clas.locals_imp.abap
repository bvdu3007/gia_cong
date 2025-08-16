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
    SELECT MAX( so_bb_num ) FROM ztb_bb_gc
        WHERE loai_hang = @ls_gia_cong-LoaiHang AND substring( ngay_lap_bb, 1, 6 ) = @ls_gia_cong-NgayLapBb(6)
         INTO @DATA(lw_so_bb_num).

    "else set overall travel status to open ('O')
    MODIFY ENTITIES OF zr_tbbb_gc IN LOCAL MODE
      ENTITY ZrTbbbGc
        UPDATE FIELDS ( SoBb )
        WITH VALUE #(
          ( %tky = ls_gia_cong-%tky
            SoBb = 'HO_12345' )
        ).

    ls_dtl-HdrID = ls_key-HdrID.
    ls_dtl-%target =  VALUE #(  ( %cid = 'ABCD123'
                                                  LoaiLoi = 'A'
                                                  ErrorCode                        = '01'
                                                  Errordesc    ='hh'
                                                  ) ) .
    APPEND ls_dtl TO lt_dtl.

    "else set overall travel status to open ('O')
    MODIFY ENTITIES OF zr_tbbb_gc IN LOCAL MODE
     ENTITY ZrTbbbGc
       CREATE BY \_dtl
            FIELDS ( LoaiLoi ErrorCode Errordesc )
               WITH lt_dtl
               REPORTED DATA(update_reported1).
  ENDMETHOD.

ENDCLASS.
