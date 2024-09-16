CLASS lhc_zbp_i_booking_zzap DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zbp_i_booking_zzap RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zbp_i_booking_zzap.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zbp_i_booking_zzap.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zbp_i_booking_zzap.

    METHODS read FOR READ
      IMPORTING keys FOR READ zbp_i_booking_zzap RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zbp_i_booking_zzap.

ENDCLASS.

CLASS lhc_zbp_i_booking_zzap IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZBP_I_BOOKING_ZZAP DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZBP_I_BOOKING_ZZAP IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
