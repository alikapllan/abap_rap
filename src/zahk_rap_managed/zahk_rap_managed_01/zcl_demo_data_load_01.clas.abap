CLASS zcl_demo_data_load_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS create_sample_so_header.
    METHODS create_sample_so_item.
    METHODS reset_sample_so_so_item.
ENDCLASS.



CLASS ZCL_DEMO_DATA_LOAD_01 IMPLEMENTATION.


  METHOD create_sample_so_header.
    DATA lv_timestamp TYPE timestampl.
    DATA lt_so_header TYPE STANDARD TABLE OF ztest_vbak_01.

    GET TIME STAMP FIELD lv_timestamp.

    lt_so_header = VALUE #( erdat                  = sy-datum
                            ernam                  = 'Alex'
                            vkorg                  = '1000'
                            vtweg                  = '10'
                            spart                  = '10'
                            netwr                  = '2000.00'
                            waerk                  = 'EUR'
                            faksk                  = ''
                            last_changed_timestamp = lv_timestamp
                            ( vbeln = '1001' )
                            ( vbeln = '1002' ) ).

    INSERT ztest_vbak_01 FROM TABLE @lt_so_header.
  ENDMETHOD.


  METHOD create_sample_so_item.

   DATA: lt_so_item TYPE STANDARD TABLE OF ztest_vbap_01,
         lv_timestamp TYPE timestampl.

    GET TIME STAMP FIELD lv_timestamp.

     lt_so_item = VALUE #(
                    (

                         vbeln          = '1001'
                         posnr          = '10'
                         matnr          = 'M-10'
                         arktx          = 'Laptop'
                         netpr          = '1000'
                         netwr          = '1000'
                         waerk          = 'EUR'
                         kpein          = '1'
                         kmein          = 'PC'
                         last_changed_timestamp = lv_timestamp
                     )
                     (

                         vbeln          = '1001'
                         posnr          = '20'
                         matnr          = 'M-20'
                         arktx          = 'Office Phone'
                         netpr          = '1000'
                         netwr          = '1000'
                         waerk          = 'EUR'
                         kpein          = '1'
                         kmein          = 'PC'
                         last_changed_timestamp = lv_timestamp
                     )
                     (

                         vbeln          = '1002'
                         posnr          = '10'
                         matnr          = 'A-20'
                         arktx          = 'Big Office Desk'
                         netpr          = '1000'
                         netwr          = '2000'
                         waerk          = 'EUR'
                         kpein          = '2'
                         kmein          = 'PC'
                         last_changed_timestamp = lv_timestamp
                     )
                   ).

        INSERT ztest_vbap_01 FROM TABLE @lt_so_item.


  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    reset_sample_so_so_item( ).
    create_sample_so_item( ).
    create_sample_so_header( ).

    IF sy-subrc = 0.
      out->write( data = 'Done' ).
    ENDIF.
  ENDMETHOD.


  METHOD reset_sample_so_so_item.

    DELETE FROM ztest_vbak_01 .
    DELETE FROM ztest_vbap_01.

  ENDMETHOD.
ENDCLASS.
