CLASS zcl_salesorder_operation_u_02 DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES t_ztest_vbak02  TYPE ztest_vbak_02.
    TYPES tt_ztest_vbak02 TYPE STANDARD TABLE OF t_ztest_vbak02.

    TYPES t_ztest_vbap02  TYPE ztest_vbap_02.
    TYPES tt_ztest_vbap02 TYPE STANDARD TABLE OF t_ztest_vbap02 WITH EMPTY KEY.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_salesorder_operation_u_02.

    METHODS delete_so_header IMPORTING it_so_header TYPE tt_ztest_vbak02.
    METHODS create_so_header IMPORTING it_so_header TYPE tt_ztest_vbak02.
    METHODS update_so_header IMPORTING it_so_header         TYPE tt_ztest_vbak02
                                       it_so_header_control TYPE zif_sales_order_structure=>tt_so_control.
    METHODS save_so_header.
    METHODS cleanup.

    METHODS create_so_item IMPORTING it_so_item TYPE tt_ztest_vbap02.
    METHODS delete_so_item IMPORTING it_so_item TYPE tt_ztest_vbap02.

    METHODS get_last_sales_doc_num RETURNING VALUE(rv_sales_doc_num) TYPE vbeln.
    METHODS block_or_unlock_so IMPORTING it_so_header    TYPE tt_ztest_vbak02
                                         iv_block_status TYPE ztest_vbak_02-faksk.
    METHODS get_item_new_posnr IMPORTING iv_so_sales_doc_num       TYPE ztest_vbap_02-vbeln
                               RETURNING VALUE(rv_new_item_posnr)  TYPE ztest_vbap_02-posnr.

  PRIVATE SECTION.
    CLASS-DATA go_instance TYPE REF TO zcl_salesorder_operation_u_02.
ENDCLASS.


CLASS zcl_salesorder_operation_u_02 IMPLEMENTATION.
  METHOD get_instance.
    go_instance = COND #( WHEN go_instance IS BOUND
                          THEN go_instance
                          ELSE NEW #( ) ).

    ro_instance = go_instance.
  ENDMETHOD.

  METHOD delete_so_header.
    " .. Some pre-processing logic
    lcl_salesorder_buffer=>get_instance( )->delete_so_header_buffer( it_so_header = it_so_header ).
    " .. Some post-processing logic
  ENDMETHOD.

  METHOD save_so_header.
    " .. Some pre-processing logic
    lcl_salesorder_buffer=>get_instance( )->save_so_header_buffer( ).
    " .. Some post-processing logic
  ENDMETHOD.

  METHOD cleanup.
    lcl_salesorder_buffer=>get_instance( )->cleanup_buffer( ).
  ENDMETHOD.

  METHOD get_last_sales_doc_num .
    rv_sales_doc_num = lcl_salesorder_buffer=>get_instance( )->get_last_sales_doc_num_buffer( ).
  ENDMETHOD.

  METHOD create_so_header.
    lcl_salesorder_buffer=>get_instance( )->create_so_header_buffer( it_so_header = it_so_header ).
  ENDMETHOD.

  METHOD update_so_header.
    lcl_salesorder_buffer=>get_instance( )->update_so_header_buffer( it_so_header         = it_so_header
                                                                     it_so_header_control = it_so_header_control ).
  ENDMETHOD.

  METHOD block_or_unlock_so.
    lcl_salesorder_buffer=>get_instance( )->block_or_unlock_so_buffer( it_so_header    = it_so_header
                                                                       iv_block_status = iv_block_status ).
  ENDMETHOD.

  METHOD get_item_new_posnr.
    rv_new_item_posnr = lcl_salesorder_buffer=>get_instance(
            )->get_item_new_posnr_buffer( iv_so_sales_doc_num = iv_so_sales_doc_num ).
  ENDMETHOD.

  METHOD create_so_item.
    lcl_salesorder_buffer=>get_instance( )->create_so_item_buffer( it_so_item = it_so_item ).
  ENDMETHOD.

  METHOD delete_so_item.
    lcl_salesorder_buffer=>get_instance( )->delete_so_item_buffer( it_so_item = it_so_item ).
  ENDMETHOD.

ENDCLASS.
