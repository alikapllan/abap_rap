@EndUserText.label: 'Entity for item creation'
define root abstract entity ZP_PopupItem
{
  @EndUserText.label: 'Product ID'
  @Consumption.valueHelpDefinition: [{
    entity: { name: 'I_ProductVH', element: 'Product' }
  }]
  ProductId : matnr;

  @EndUserText.label: 'Amount'
  @Semantics.quantity.unitOfMeasure: 'ProductUom'
  ProductAmount : kwmeng;

  @EndUserText.label: 'Unit'
  @Consumption.valueHelpDefinition: [{
    entity: { name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure' }
  }]
  ProductUom : vrkme;
}
