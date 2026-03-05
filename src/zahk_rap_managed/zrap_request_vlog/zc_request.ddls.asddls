@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Request Projection View'

@Metadata.allowExtensions: true

@ObjectModel.semanticKey: [ 'ExternalId' ]

@Search.searchable: true

define root view entity ZC_Request
  provider contract transactional_query
  as projection on ZI_Request

{
  key RequestUuid,

      @Search.defaultSearchElement: true
      ExternalId,


      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_BusinessPartnerVH', element: 'BusinessPartner' },
                                            useForValidation: true } ]
      @ObjectModel.text.element: [ 'RequesterName' ]
      @Search.defaultSearchElement: true
      RequesterId,

      _requester.BusinessPartnerName as RequesterName,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_Status_Edit_VH', element: 'Status' } } ]
      @ObjectModel.text.element: [ 'StatusText' ]
      @Search.defaultSearchElement: true
      Status,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_Status_VH', element: 'Status' } } ]
      @ObjectModel.text.element: [ 'StatusText' ]
      @Search.defaultSearchElement: true
      Status                         as StatusFilter,

      _status.StatusText             as StatusText,

      StatusCriticality,


      @Consumption.filter.selectionType: #SINGLE
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_Priority_VH', element: 'Priority' },
                                            useForValidation: true } ]
      @ObjectModel.text.element: [ 'PriorityText' ]
      @Search.defaultSearchElement: true
      // The selection type is set to SINGLE, as the priority can only have one value for each request. 
      // This allows the Fiori elements to render the priority field as a dropdown with single selection.
      Priority,

      _priority.PriorityText         as PriorityText,

      DeadlineDate,
      CancelReason,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_RAP_REQUEST_CALC_EXIT'
      virtual CancelReasonHidden : abap_boolean,
      LastChangedAt,

      /* Associations */
      _items : redirected to composition child ZC_RequestItem,

      _requester,
      _priority,
      _status
}
