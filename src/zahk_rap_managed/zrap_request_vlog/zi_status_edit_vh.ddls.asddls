@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Status edit value help'

@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZI_Status_Edit_VH
  as select from ZI_Status_VH

{
      @ObjectModel.text.element: [ 'StatusText' ]
  key Status,

      StatusText
}

where Status <> '103'; // Cancelled
