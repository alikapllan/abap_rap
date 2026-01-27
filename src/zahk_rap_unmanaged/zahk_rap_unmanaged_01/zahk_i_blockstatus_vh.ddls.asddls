@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Block Status Value help'

@ObjectModel.resultSet.sizeCategory: #XS // value help in dropdown list

define view entity ZAHK_I_BLOCKSTATUS_VH
  as select from     I_DomainFixedValue

    left outer join I_DomainFixedValueText
      on  I_DomainFixedValue.SAPDataDictionaryDomain = I_DomainFixedValueText.SAPDataDictionaryDomain
      and I_DomainFixedValue.DomainValuePosition     = I_DomainFixedValueText.DomainValuePosition // for uniqueness
      and I_DomainFixedValueText.Language            = $session.system_language

{
      // to see both code and description in value help dropdown
      @ObjectModel.text.element: [ 'BlockStatusDescription' ]
      @UI.textArrangement: #TEXT_LAST
  key I_DomainFixedValue.DomainValue    as BlockStatus,

      @Semantics.text: true
      I_DomainFixedValueText.DomainText as BlockStatusDescription
}

where I_DomainFixedValue.SAPDataDictionaryDomain = 'ZAHK_BLOCK_STATUS';
