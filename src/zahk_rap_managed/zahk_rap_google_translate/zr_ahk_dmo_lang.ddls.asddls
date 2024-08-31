@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '##GENERATED ZAHK_DMO_LANG'
define root view entity ZR_AHK_DMO_LANG
  as select from zahk_dmo_lang as Language
{
  key identification as Identification,
  source_language as SourceLanguage,
  source_text as SourceText,
  target_language as TargetLanguage,
  target_text as TargetText,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed as LastChanged
  
}
