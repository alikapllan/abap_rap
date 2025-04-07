CLASS zcl_rapdemo02_data_insert DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS add_data_from_ztest_userinfo01.
ENDCLASS.



CLASS ZCL_RAPDEMO02_DATA_INSERT IMPLEMENTATION.


  METHOD add_data_from_ztest_userinfo01.
    SELECT FROM ztest_userinfo01
      FIELDS *
      INTO TABLE @DATA(lt_userinfo).

    IF sy-subrc = 0.
      MODIFY ztest_userinfo02 FROM TABLE @lt_userinfo.
    ENDIF.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    add_data_from_ztest_userinfo01( ).
  ENDMETHOD.
ENDCLASS.
