*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lhc_user DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
*   ACTION
    " Method name does not have to be same with in ACTION
    METHODS set_user_to_admin FOR MODIFY IMPORTING keys
                              FOR ACTION Zahk_I_userinfo_m_02~makeUserAdmin
                              RESULT result.

    METHODS removeUserAdmin   FOR MODIFY IMPORTING keys
                              FOR ACTION Zahk_I_userinfo_m_02~removeUserAdmin
                              RESULT result.

*   VALIDATION
    METHODS validEmail FOR VALIDATE ON SAVE IMPORTING keys
                       FOR Zahk_I_userinfo_m_02~validEmail. " no result, as an error in this case is thrown

*   DETERMINATION
    METHODS assignAdmin FOR DETERMINE ON MODIFY IMPORTING keys
                        FOR Zahk_I_userinfo_m_02~assignAdmin.
ENDCLASS.


CLASS lhc_user IMPLEMENTATION.
  METHOD set_user_to_admin.
    LOOP AT keys REFERENCE INTO DATA(key).
      " for production cases use -> FM, BAPI, Public/Remote API
*      UPDATE ztest_userinfo01 SET is_admin = 'YES' WHERE user_mail = @key->Email.
      UPDATE ztest_userinfo01 SET is_admin = 'YES' WHERE user_mail = @key->%key-Email.
      IF sy-subrc = 0.
        APPEND VALUE #( Email          = key->%key-Email
                        %param-Email   = key->%key-Email
                        %param-IsAdmin = 'YES' ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD removeUserAdmin.
    LOOP AT keys REFERENCE INTO DATA(key).
      UPDATE ztest_userinfo01 SET is_admin = 'NO' WHERE user_mail = @key->%key-Email.
      IF sy-subrc = 0.
        APPEND VALUE #( Email          = key->%key-Email
                        %param-Email   = key->%key-Email
                        %param-IsAdmin = 'NO' ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validEmail.
    LOOP AT keys REFERENCE INTO DATA(key).
      IF abap_false = cl_abap_matcher=>create( pattern     = '\w+(\.\w+)*@(\w+\.)+(\w{2,4})'
                                               text        = to_lower( key->%key-Email )
                                               ignore_case = abap_true )->match( ).
        " --> wrong email input <--

        APPEND VALUE #( Email = key->%key-Email ) TO failed-zahk_i_userinfo_m_02.

        " Error message to User -> done over REPORTED
        APPEND VALUE #( Email = key->%key-Email
                        %msg  = new_message( id       = 'ZTEST_USERINFO01' " Message Class
                                             number   = 000
                                             severity = if_abap_behv_message=>severity-error
                                             v1       = key->%key-Email ) ) " Placeholder of the message within mes. class
               TO reported-zahk_i_userinfo_m_02.

      ELSE.
        " here is reached if the email is provided properly

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD assignAdmin.
    LOOP AT keys REFERENCE INTO DATA(key).
      IF to_lower( key->%key-Email ) CS 'admin'.

        MODIFY ENTITY IN LOCAL MODE Zahk_I_userinfo_m_02 " composite root view
               UPDATE FIELDS ( IsAdmin )
               WITH VALUE #( ( Email   = key->%key-Email
                               IsAdmin = 'YES' ) ).
      ELSE.
        MODIFY ENTITY IN LOCAL MODE Zahk_I_userinfo_m_02
               UPDATE FIELDS ( IsAdmin )
               WITH VALUE #( ( Email   = key->%key-Email
                               IsAdmin = 'NO' ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
