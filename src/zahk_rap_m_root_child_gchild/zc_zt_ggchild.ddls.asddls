@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Projection View for ZR_ZT_GGCHILD'
define view entity ZC_ZT_GGCHILD
  as projection on ZR_ZT_GGCHILD
{
  key UuidGgchild,
      SemantickeyGgchild,
      Description,
      UuidRoot,
      UuidChild,
      UuidGchild,
      Createdby,
      Createdat,
      Changedby,
      Lastchangedat,
      Locallastchangedat,
      /* Associations */
      _Child      : redirected to ZC_ZT_CHILD,
      _GrandChild : redirected to parent ZC_ZT_GCHILD,
      _Root       : redirected to ZC_ZT_ROOT
}
