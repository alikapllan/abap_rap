@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Composite View'
@Metadata.allowExtensions: true

define view entity ZAHK_I_SALES_ITEM_M_02
  as select from zahk_i_sales_item_02
  association to parent ZAHK_I_SALES_HEADER_M_02 as _SHeader_M_02 
    on $projection.sales_doc_num = _SHeader_M_02.sales_doc_num
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
      _SHeader_M_02
}
