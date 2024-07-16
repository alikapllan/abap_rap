@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Item Basic View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@ObjectModel.representativeKey: 'item_position' // here posnr is repre. key
@ObjectModel.semanticKey: [ 'sales_doc_num','item_position' ] // 2 keys on table

define view entity zahk_i_sales_item_01 as select from ztest_vbap_01
    association [1..1] to ZAHK_I_SALES_HEADER_01 as _SD_Head_01
        on $projection.sales_doc_num = _SD_Head_01.sales_doc_num
{
    key vbeln as sales_doc_num,
    key posnr as item_position,
    matnr as mat_num,
    
    @Semantics.text: true
    arktx as mat_desc,
    
    @Semantics.amount.currencyCode: 'cost_currency'
    netpr as unit_cost,
    @Semantics.amount.currencyCode: 'cost_currency'
    netwr as total_item_cost,
    
    waerk as cost_currency,
    
    @Semantics.quantity.unitOfMeasure: 'unit'
    kpein as quantity,
    kmein as unit,
    last_changed_timestamp as last_changed_on,
    
    _SD_Head_01
}
