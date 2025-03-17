@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_ZT_ROOT'
define root view entity ZC_ZT_ROOT
  provider contract transactional_query
  as projection on ZR_ZT_ROOT
{
  key UuidRoot,
      SemantickeyRoot,
      Description,
      Createdby,
      Createdat,
      Changedby,
      Lastchangedat,
      Locallastchangedat,
      _Child           : redirected to composition child ZC_ZT_CHILD,
      _GrandChild      : redirected to ZC_ZT_GCHILD,
      _GreatGrandChild : redirected to ZC_ZT_GGCHILD
}
