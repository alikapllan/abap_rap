@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Composite View'
@Metadata.allowExtensions: true

define view entity ZAHK_I_SALES_ITEM_M_01 as select from zahk_i_sales_item_01
  association to parent ZAHK_I_SALES_HEADER_M_01 as _SHeader_M_01
  on $projection.sales_doc_num = _SHeader_M_01.sales_doc_num
{
  key sales_doc_num,
  key item_position,
  mat_num,
  mat_desc,
  unit_cost,
  total_item_cost,
  cost_currency,
  quantity,
  unit,
  last_changed_on,
  
  /* Associations */
  //_SD_Head_01
  _SHeader_M_01
}
