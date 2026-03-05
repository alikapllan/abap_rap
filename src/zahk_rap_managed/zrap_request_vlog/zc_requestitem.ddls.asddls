@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Request Item Projection View'

@Metadata.allowExtensions: true

define view entity ZC_RequestItem
  as projection on ZI_RequestItem

{
  key RequestUuid,
  key ItemUuid,

      ProductId,
      ProductQty,
      ProductUom,
      LastChangedAt,
      /* Associations */
      _Request : redirected to parent ZC_Request
}
