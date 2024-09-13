@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composition Root View ztest_userinfo01'
@Metadata.allowExtensions: true
// modeling data For UI
@VDM.viewType: #CONSUMPTION
define root view entity Zahk_I_userinfo_m_02 as select from Zahk_I_userinfo_m_01
{
    key UserMail as Email,
    FirstName,
    LastName,
    IsAdmin,
    concat_with_space(FirstName, LastName, 1) as FullName,
    
    @Semantics.systemDateTime.lastChangedAt: true
    LastChanged
}
