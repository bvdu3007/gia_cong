@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Chi tiết lỗi gia công'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_gc_loi as select from ztb_gc_loi
association to parent ZI_BB_GC as _hdr
    on $projection.HdrId = _hdr.HdrId
association [1..1] to ZR_TB_LOI_H_DTL   as _loi 
on $projection.LoaiLoi = _loi.LoaiLoi and $projection.ErrorCode = _loi.ErrorCode 
and $projection.LoaiHang = _loi.LoaiHang

{
    key hdr_id as HdrId,
    key dtl_id as DtlId,
    loai_loi as LoaiLoi,
    loai_hang as LoaiHang,
    error_code as ErrorCode,
    errordesc as Errordesc,
    sl_loi as SlLoi,
    _loi.bangi,
    _loi.bangii,
    _hdr // Make association public
}
