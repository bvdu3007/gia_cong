@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Thông tin PO gia công'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_PO_GC as select 
from I_PurchaseOrderAPI01 as Po
inner join I_Supplier_VH as Sup on Po.Supplier = Sup.Supplier
inner join I_PurOrdAccountAssignmentAPI01   as Pur on Po.PurchaseOrder = Pur.PurchaseOrder
inner join I_ManufacturingOrderItem as Man on Pur.OrderID = Man.ManufacturingOrder
{
    key Po.PurchaseOrder,
    Po.Supplier,
    Sup.SupplierName,
    Pur.OrderID
    
}
