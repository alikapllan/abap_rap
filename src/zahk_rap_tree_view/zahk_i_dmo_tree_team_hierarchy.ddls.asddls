define hierarchy ZAHK_I_DMO_TREE_TEAM_HIERARCHY
  as parent child hierarchy(
    source ZR_AHK_DMO_TEAM // on this level INTERFACE view as source
    child to parent association _TeamLeader
    start where
      TeamLeader is initial
    siblings order by
      PlayerName ascending
  )
{
  key UserID,
      TeamLeader
}
