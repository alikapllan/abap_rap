*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lhc_user DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
*   ACTION
    " Method name does not have to be same with in ACTION
    METHODS set_user_to_admin FOR MODIFY IMPORTING keys
                                                     FOR ACTION zahk_i_userinfo_m_02~makeuseradmin
                                         RESULT    result.

    METHODS removeuseradmin   FOR MODIFY IMPORTING keys
                                                     FOR ACTION zahk_i_userinfo_m_02~removeuseradmin
                                         RESULT    result.

*   VALIDATION
    METHODS validemail FOR VALIDATE ON SAVE IMPORTING keys
                                                        FOR zahk_i_userinfo_m_02~validemail. " no result, as an error in this case is thrown

*   DETERMINATION
    METHODS assignadmin FOR DETERMINE ON MODIFY IMPORTING keys
                                                            FOR zahk_i_userinfo_m_02~assignadmin.
ENDCLASS.


CLASS lhc_user IMPLEMENTATION.
  METHOD set_user_to_admin.
    LOOP AT keys REFERENCE INTO DATA(key).
      " for production cases use -> FM, BAPI, Public/Remote API
*      UPDATE ztest_userinfo01 SET is_admin = 'YES' WHERE user_mail = @key->Email.
      UPDATE ztest_userinfo01 SET is_admin = 'YES' WHERE user_mail = @key->%key-email.
      IF sy-subrc = 0.
        APPEND VALUE #( email          = key->%key-email
                        %param-email   = key->%key-email
                        %param-isadmin = 'YES' ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD removeuseradmin.
    LOOP AT keys REFERENCE INTO DATA(key).
      UPDATE ztest_userinfo01 SET is_admin = 'NO' WHERE user_mail = @key->%key-email.
      IF sy-subrc = 0.
        APPEND VALUE #( email          = key->%key-email
                        %param-email   = key->%key-email
                        %param-isadmin = 'NO' ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validemail.
    LOOP AT keys REFERENCE INTO DATA(key).
      IF abap_false = cl_abap_matcher=>create( pattern     = '\w+(\.\w+)*@(\w+\.)+(\w{2,4})'
                                               text        = to_lower( key->%key-email )
                                               ignore_case = abap_true )->match( ).
        " --> wrong email input <--

        APPEND VALUE #( email = key->%key-email ) TO failed-zahk_i_userinfo_m_02.

        " Error message to User -> done over REPORTED
        APPEND VALUE #( email = key->%key-email
                        %msg  = new_message( id       = 'ZTEST_USERINFO01' " Message Class
                                             number   = 000
                                             severity = if_abap_behv_message=>severity-error
                                             v1       = key->%key-email ) ) " Placeholder of the message within mes. class
               TO reported-zahk_i_userinfo_m_02.

      ELSE.
        " here is reached if the email is provided properly

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD assignadmin.
    LOOP AT keys REFERENCE INTO DATA(key).
      IF to_lower( key->%key-email ) CS 'admin'.

        MODIFY ENTITY IN LOCAL MODE zahk_i_userinfo_m_02 " composite root view
               UPDATE FIELDS ( isadmin )
               WITH VALUE #( ( email   = key->%key-email
                               isadmin = 'YES' ) ).
      ELSE.
        MODIFY ENTITY IN LOCAL MODE zahk_i_userinfo_m_02
               UPDATE FIELDS ( isadmin )
               WITH VALUE #( ( email   = key->%key-email
                               isadmin = 'NO' ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
