@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Biên bản gia công'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_BB_GC as select from ztb_bb_gc
    composition [0..*] of zi_gc_loi as _dtl
    association [1..1] to ZV_PO_GC        as _Po
      on $projection.SoPo = _Po.PurchaseOrder
{
    key hdr_id         as HdrId,
    loai_hang          as LoaiHang,
    so_bb              as SoBb,
    so_bb_num          as SoBbNum,
    so_po              as SoPo,
    // Lấy Supplier trực tiếp từ association _Po
    _Po.Supplier       as Supplier,    
    // Lấy tên Supplier từ association _Sup
    _Po.SupplierName,
    _Po.OrderID        as OrderID,
    ngay_nhap_hang     as NgayNhapHang,
    ngay_tra_bb        as NgayTraBb,
    ngay_nhap_kho      as NgayNhapKho,
    tong_cai           as TongCai,
    sl_kiem            as SlKiem,
    sl_chap            as SlChap,
    ghi_chu            as GhiChu,
    sau_kcs_tong       as SauKcsTong,
    tra_cham_0xuat     as TraCham0xuat,
    tra_cham_xuat      as TraChamXuat,
    tra_ve_gc          as TraVeGc,
    tra_ve_cty         as TraVeCty,
    loi_cty_manh       as LoiCtyManh,
    loi_cty_in         as LoiCtyIn,
    loi_cty_ban        as LoiCtyBan,
    loi_cty_contrung   as LoiCtyContrung,
    loi_cty_phe_thu    as LoiCtyPheThu,
    loi_cty_khac       as LoiCtyKhac,
    loi_gc_ban         as LoiGcBan,
    loi_gc_rach        as LoiGcRach,
    loi_gc_saiqc       as LoiGcSaiqc,
    loi_gc_mayxau      as LoiGcMayxau,
    loi_gc_lochankim   as LoiGcLochankim,
    loi_gc_nhaunat     as LoiGcNhaunat,

    _dtl // make association public
}
