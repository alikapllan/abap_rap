@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '##GENERATED ZZT_ROOT'
define root view entity ZR_ZT_ROOT
  as select from zzt_root as Root
  composition [*] of ZR_ZT_CHILD      as _Child
  association [0..*] to ZR_ZT_GCHILD  as _GrandChild      on $projection.UuidRoot = _GrandChild.UuidRoot
  association [0..*] to ZR_ZT_GGCHILD as _GreatGrandChild on $projection.UuidRoot = _GreatGrandChild.UuidRoot
{
  key uuid_root          as UuidRoot,
      semantickey_root   as SemantickeyRoot,
      description        as Description,
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
      _Child,
      _GrandChild,
      _GreatGrandChild
}
