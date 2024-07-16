@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Doc Basic View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.representativeKey: 'sales_doc_num'
@ObjectModel.semanticKey: [ 'sales_doc_num' ]

define view entity ZAHK_I_SALES_HEADER_01 as select from ztest_vbak_01
    association [0..*] to zahk_i_sales_item_01 as _SD_Item_01
    on $projection.sales_doc_num = _SD_Item_01.sales_doc_num
{
    key vbeln as sales_doc_num,
    erdat as date_created,
    
    @Semantics.user.createdBy: true
    ernam as person_created,
    vkorg as sales_org,
    vtweg as sales_dist,
    spart as sales_div,
    
    @Semantics.amount.currencyCode: 'cost_currency'
    netwr as total_cost,
    waerk as cost_currency,
    faksk as block_status,
    
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_timestamp as last_changed_on,
    
    _SD_Item_01
}
