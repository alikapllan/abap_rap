@EndUserText.label: 'zbp_i_booking_zzap'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity zbp_i_booking_zzap as select from zahk_i_booking
{
    key z_no as ZNo
}
