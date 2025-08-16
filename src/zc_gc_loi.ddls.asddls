@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Chi tiết lỗi gia công'
@Metadata.ignorePropagatedAnnotations: true
define view entity zc_gc_loi as projection on zi_gc_loi
{
    key HdrId,
    key DtlId,
    LoaiLoi,
    LoaiHang,
    ErrorCode,
    Errordesc,
    SlLoi,
    bangi,
    CheckBangi,
    bangii,
    CheckBangii,
    GhiChu,
    /* Associations */
    _hdr  : redirected to parent zc_bb_gc
}
