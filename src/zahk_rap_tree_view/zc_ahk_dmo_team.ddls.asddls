@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_AHK_DMO_TEAM'
// Annotation to enable tree view - here the new hierarchical view is given
@OData.hierarchy.recursiveHierarchy:[{ entity.name: 'ZAHK_I_DMO_TREE_TEAM_HIERARCHY' }]
define root view entity ZC_AHK_DMO_TEAM
  provider contract transactional_query
  as projection on ZR_AHK_DMO_TEAM
  association of many to one ZC_AHK_DMO_TEAM as _TeamLeader on $projection.TeamLeader = _TeamLeader.UserID
{
  key UserID,
  PlayerName,
  PlayerEmail,
  PlayerPosition,
  Score,
  Team,
  TeamLeader,
  LocalLastChanged,
  
  _TeamLeader
}
