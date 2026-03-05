@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Status value help'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZI_Status_VH
  as select from dd07l as values

    inner join   dd07t as texts
      on  values.domname    = texts.domname
      and values.domvalue_l = texts.domvalue_l

{
      @ObjectModel.text.element: [ 'StatusText' ]
  key values.domvalue_l as Status,

      texts.ddtext      as StatusText
}

where values.domname   = 'ZRAP_STATUS_D'
  and texts.domname    = 'ZRAP_STATUS_D'
  and texts.ddlanguage = $session.system_language;
