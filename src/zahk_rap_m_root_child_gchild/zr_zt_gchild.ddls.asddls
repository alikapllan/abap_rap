@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '##GENERATED ZZT_GCHILD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_ZT_GCHILD
  as select from zzt_gchild
  association to ZR_ZT_ROOT         as _Root  on $projection.UuidRoot = _Root.UuidRoot
  association to parent ZR_ZT_CHILD as _Child on $projection.UuidChild = _Child.UuidChild
  composition [*] of ZR_ZT_GGCHILD  as _GreatGrandChild
{
  key uuid_gchild        as UuidGchild,
      semantickey_gchild as SemantickeyGchild,
      description        as Description,
      uuid_root          as UuidRoot,
      uuid_child         as UuidChild,
      @Semantics.user.createdBy: true
      createdby          as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat          as Createdat,
      @Semantics.user.localInstanceLastChangedBy: true
      changedby          as Changedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat      as Lastchangedat,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat as Locallastchangedat,
      _Root,
      _Child,
      _GreatGrandChild
}
