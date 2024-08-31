@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unm.-Consmption/Projection View for Item'
@Metadata.allowExtensions: true
define view entity zahk_c_sales_item_u_02
  as projection on ZAHK_I_SALES_ITEM_M_02
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
      _SHeader_M_02 : redirected to parent zahk_c_sales_header_u_02
}
