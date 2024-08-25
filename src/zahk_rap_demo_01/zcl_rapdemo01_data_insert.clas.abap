CLASS zcl_rapdemo01_data_insert DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS add_user_data.
    methods reset_admin_all_user.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RAPDEMO01_DATA_INSERT IMPLEMENTATION.


  METHOD add_user_data.
    DATA lt_userinfo TYPE STANDARD TABLE OF ztest_userinfo01.

    lt_userinfo = VALUE #( ( user_mail  = 'ahk@gmail.com'
                             first_name = 'Ali'
                             last_name  = 'Kaplan' )
                           ( user_mail  = 'warummacheichdas@gmail.com'
                             first_name = 'Moritz'
                             last_name  = 'Bleibtreu' )
                           ( user_mail  = 'ihatesap@gmail.com'
                             first_name = 'Nuri'
                             last_name  = 'Sahin' ) ).

    MODIFY ztest_userinfo01 FROM TABLE @lt_userinfo.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    add_user_data( ).
    reset_admin_all_user( ).
  ENDMETHOD.


  METHOD reset_admin_all_user.
    UPDATE ztest_userinfo01 SET is_admin = 'NO'.
  ENDMETHOD.
ENDCLASS.
