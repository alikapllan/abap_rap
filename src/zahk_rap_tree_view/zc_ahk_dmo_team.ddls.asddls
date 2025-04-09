@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_AHK_DMO_TEAM'
@ObjectModel.semanticKey: [ 'UserID' ]
define root view entity ZC_AHK_DMO_TEAM
  provider contract transactional_query
  as projection on ZR_AHK_DMO_TEAM
{
  key UserID,
  PlayerName,
  PlayerEmail,
  PlayerPosition,
  Score,
  Team,
  TeamLeader,
  LocalLastChanged
  
}
