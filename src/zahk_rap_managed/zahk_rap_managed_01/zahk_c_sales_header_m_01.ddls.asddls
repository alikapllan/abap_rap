@EndUserText.label: 'Projection View - Sales Header'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZAHK_C_SALES_HEADER_M_01
  provider contract transactional_query
  as projection on ZAHK_I_SALES_HEADER_M_01 
{
  key sales_doc_num,
      date_created,
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
