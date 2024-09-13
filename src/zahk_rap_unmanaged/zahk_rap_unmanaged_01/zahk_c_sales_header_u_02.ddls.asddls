@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unm.-Consmption/Projection View for Head'
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION
define root view entity zahk_c_sales_header_u_02
  provider contract transactional_query
  as projection on ZAHK_I_SALES_HEADER_M_02
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
      _SItem_M_02 : redirected to composition child zahk_c_sales_item_u_02
}
