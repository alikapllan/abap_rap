@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '##GENERATED ZZT_CHILD'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_ZT_CHILD
  as select from zzt_child
  association        to parent ZR_ZT_ROOT as _Root            on $projection.UuidRoot = _Root.UuidRoot
  composition [*] of ZR_ZT_GCHILD         as _GrandChild
  association [0..*] to ZR_ZT_GGCHILD     as _GreatGrandChild on $projection.UuidChild = _GreatGrandChild.UuidChild
{
  key uuid_child         as UuidChild,
      semantickey_child  as SemantickeyChild,
      description        as Description,
      uuid_root          as UuidRoot,
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
      _GrandChild,
      _GreatGrandChild
}
