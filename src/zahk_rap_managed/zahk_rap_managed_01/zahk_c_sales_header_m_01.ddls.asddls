@EndUserText.label: 'Projection View - Sales Header'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION
@ObjectModel : { resultSet.sizeCategory: #XS } // with this annotation Search helps appears as dropdown list
@Search.searchable: true 
define root view entity ZAHK_C_SALES_HEADER_M_01
  provider contract transactional_query
  as projection on ZAHK_I_SALES_HEADER_M_01
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZAHK_C_SALES_HEADER_M_01', element: 'sales_doc_num' } }]
  key sales_doc_num,
      date_created,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      person_created,
      sales_org,
      sales_dist,
      sales_div,
      total_cost,
      cost_currency,
      block_status,
      block_status_msg,
      last_changed_on,
      /* Associations */
      _SItem_M_01 : redirected to composition child ZAHK_C_SALES_ITEM_M_01
}
