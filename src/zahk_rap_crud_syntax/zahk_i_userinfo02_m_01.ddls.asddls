@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interfce-Basic View for ztest_userinfo02'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zahk_I_userinfo02_m_01 as select from ztest_userinfo02
{
    key user_mail as UserMail,
    first_name as FirstName,
    last_name as LastName,
    is_admin as IsAdmin,
    last_changed as LastChanged
}
