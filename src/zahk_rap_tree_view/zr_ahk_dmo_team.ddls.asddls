@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED zAHK_DMO_TEAM'
define root view entity ZR_AHK_DMO_TEAM
  as select from zahk_dmo_team
{
  key user_id as UserID,
  player_name as PlayerName,
  player_email as PlayerEmail,
  player_position as PlayerPosition,
  score as Score,
  team as Team,
  team_leader as TeamLeader,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed as LastChanged
  
}
