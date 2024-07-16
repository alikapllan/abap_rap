@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for ztest_userinfo01'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zahk_I_userinfo_m_01 as select from ztest_userinfo01
{
    key user_mail as UserMail,
    first_name as FirstName,
    last_name as LastName,
    is_admin as IsAdmin,
    last_changed as LastChanged
}
