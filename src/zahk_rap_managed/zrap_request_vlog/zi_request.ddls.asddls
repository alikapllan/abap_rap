@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Request Interface View'

@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_Request
  as select from zrap_a_request

  composition of exact one to many        ZI_RequestItem    as _items
  association of one               to one I_BusinessPartner as _requester on _requester.BusinessPartner = $projection.RequesterId
  association of one               to one ZI_Priority_VH    as _priority  on _priority.Priority = $projection.Priority
  association of one               to one ZI_Status_VH      as _status    on _status.Status = $projection.Status

{
  key request_uuid    as RequestUuid,

      status          as Status,
      priority        as Priority,
      external_id     as ExternalId,
      deadline_date   as DeadlineDate,
      requester_id    as RequesterId,
      cancel_reason   as CancelReason,

      case status
      when '101' then 2
      when '102' then 3
      when '103' then 1
      else 0 end      as StatusCriticality,


      @Semantics.user.createdBy: true
      created_by      as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      // associations
      _items,
      _requester,
      _priority,
      _status
}
