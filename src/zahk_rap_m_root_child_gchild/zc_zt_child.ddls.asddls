@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Projection View for ZR_ZT_CHILD'
define view entity ZC_ZT_CHILD
  as projection on ZR_ZT_CHILD
{
  key UuidChild,
      SemantickeyChild,
      Description,
      UuidRoot,
      Createdby,
      Createdat,
      Changedby,
      Lastchangedat,
      Locallastchangedat,
      /* Associations */
      _Root            : redirected to parent ZC_ZT_ROOT,
      _GrandChild      : redirected to composition child ZC_ZT_GCHILD,
      _GreatGrandChild : redirected to ZC_ZT_GGCHILD
}
