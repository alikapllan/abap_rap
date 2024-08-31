@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_AHK_DMO_LANG'
@Search.searchable: true
define root view entity ZC_AHK_DMO_LANG
  provider contract transactional_query
  as projection on ZR_AHK_DMO_LANG 
{
  key Identification,
  
  // value help
  @Consumption.valueHelpDefinition: [{ entity: {
      name: 'I_Language',
      element: 'LanguageISOCode'
  } }]
  SourceLanguage,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.7
  SourceText,
  
  @Consumption.valueHelpDefinition: [{ entity: {
      name: 'I_Language',
      element: 'LanguageISOCode'
  } }]
  TargetLanguage,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.7
  TargetText,
  
  LocalCreatedBy,
  LocalLastChangedBy,
  LocalLastChanged,
  LastChanged
}
