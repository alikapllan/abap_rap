@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Priority Value help'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZI_Priority_VH
  as select from dd07l as values

    inner join   dd07t as texts
      on  values.domname    = texts.domname
      and values.domvalue_l = texts.domvalue_l

{
  @ObjectModel.text.element: [ 'PriorityText' ] 
  key values.domvalue_l as Priority,

      texts.ddtext      as PriorityText
}

where values.domname   = 'ZRAP_PRIORITY_D'
  and texts.domname    = 'ZRAP_PRIORITY_D'
  and texts.ddlanguage = $session.system_language;

// Cloud version
//define view entity ZI_Priority_VH
//  as select from DDCDS_CUSTOMER_DOMAIN_VALUE(
//                   p_domain_name : 'ZRAP_PRIORITY_D') as values
//
//    inner join   DDCDS_CUSTOMER_DOMAIN_VALUE_T(
//                   p_domain_name : 'ZRAP_PRIORITY_D') as texts
//      on  values.domain_name = texts.domain_name
//      and values.value_low   = texts.value_low
//
//{
//  key values.value_low as Priority,
//
//      texts.text       as PriorityText
//}
//
//where texts.language = $session.system_language;
