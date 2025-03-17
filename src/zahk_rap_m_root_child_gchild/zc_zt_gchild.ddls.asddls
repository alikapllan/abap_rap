@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Projection View for ZR_ZT_GCHILD'
define view entity ZC_ZT_GCHILD
  as projection on ZR_ZT_GCHILD
{
  key UuidGchild,
      SemantickeyGchild,
      Description,
      UuidRoot,
      UuidChild,
      Createdby,
      Createdat,
      Changedby,
      Lastchangedat,
      Locallastchangedat,
      /* Associations */
      _Child           : redirected to parent ZC_ZT_CHILD,
      _GreatGrandChild : redirected to composition child ZC_ZT_GGCHILD,
      _Root            : redirected to ZC_ZT_ROOT
}
