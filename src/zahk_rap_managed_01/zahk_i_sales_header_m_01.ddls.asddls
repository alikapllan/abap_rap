@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root CDS View Sales Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
// this is called 'root' because a behaviour&service definition will be attached (UI)
// Top Level in the hierarchy
define root view entity ZAHK_I_SALES_HEADER_M_01 as select from ZAHK_I_SALES_HEADER_01 // select from other CDS
   composition [0..*] of ZAHK_I_SALES_ITEM_M_01 as _SItem_M_01
{
    key sales_doc_num,
    date_created,
    person_created,
    sales_org,
    sales_dist,
    sales_div,
    @Semantics.amount.currencyCode: 'cost_currency'
    total_cost,
    cost_currency,
    block_status,
    last_changed_on,
    
    /* Associations */
    // _SD_Item_01
    _SItem_M_01
}
