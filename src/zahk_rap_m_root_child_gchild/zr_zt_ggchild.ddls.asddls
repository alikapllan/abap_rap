@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '##GENERATED ZZT_GGCHILD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_ZT_GGCHILD
  as select from zzt_ggchild
  association to ZR_ZT_ROOT          as _Root       on $projection.UuidRoot = _Root.UuidRoot
  association to ZR_ZT_CHILD         as _Child      on $projection.UuidChild = _Child.UuidChild
  association to parent ZR_ZT_GCHILD as _GrandChild on $projection.UuidGchild = _GrandChild.UuidGchild
{
  key uuid_ggchild        as UuidGgchild,
      semantickey_ggchild as SemantickeyGgchild,
      description         as Description,
      uuid_root           as UuidRoot,
      uuid_child          as UuidChild,
      uuid_gchild         as UuidGchild,
      @Semantics.user.createdBy: true
      createdby           as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat           as Createdat,
      @Semantics.user.localInstanceLastChangedBy: true
      changedby           as Changedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat       as Lastchangedat,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat  as Locallastchangedat,
      _Root,
      _Child,
      _GrandChild
}
