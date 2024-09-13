@EndUserText.label: 'Projection View - Sales Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION
define view entity ZAHK_C_SALES_ITEM_M_01
  as projection on ZAHK_I_SALES_ITEM_M_01
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
      _SHeader_M_01 : redirected to parent ZAHK_C_SALES_HEADER_M_01
}
