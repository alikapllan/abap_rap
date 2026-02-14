CLASS zcl_salesorder_operation_u_02 DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE. " by adding PRIVATE -> this class cannot be instantiated outside of the class.
  " -> meaning we force to use get_instance to have an instance.

  PUBLIC SECTION.
    TYPES t_ztest_vbak02  TYPE ztest_vbak_02.
    TYPES tt_ztest_vbak02 TYPE STANDARD TABLE OF t_ztest_vbak02.

    TYPES t_ztest_vbap02  TYPE ztest_vbap_02.
    TYPES tt_ztest_vbap02 TYPE STANDARD TABLE OF t_ztest_vbap02 WITH EMPTY KEY.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_salesorder_operation_u_02.

    METHODS delete_so_header IMPORTING it_so_header TYPE tt_ztest_vbak02.

    METHODS create_so_header IMPORTING it_so_header  TYPE tt_ztest_vbak02
                             RETURNING VALUE(ro_msg) TYPE REF TO if_abap_behv_message.

    METHODS update_so_header IMPORTING it_so_header         TYPE tt_ztest_vbak02
                                       it_so_header_control TYPE zif_sales_order_structure=>tt_so_control.

    METHODS save_so_header.
    METHODS cleanup.

    METHODS create_so_item         IMPORTING it_so_item              TYPE tt_ztest_vbap02.
    METHODS delete_so_item         IMPORTING it_so_item              TYPE tt_ztest_vbap02.

    METHODS get_last_sales_doc_num RETURNING VALUE(rv_sales_doc_num) TYPE vbeln.

    METHODS block_sales_order_buffer IMPORTING it_so_header    TYPE tt_ztest_vbak02
                                               iv_block_status TYPE ztest_vbak_02-faksk.

    METHODS unblock_sales_order_buffer IMPORTING it_so_header    TYPE tt_ztest_vbak02
                                                 iv_block_status TYPE ztest_vbak_02-faksk.

    METHODS get_item_new_posnr IMPORTING iv_so_sales_doc_num      TYPE ztest_vbap_02-vbeln
                               RETURNING VALUE(rv_new_item_posnr) TYPE ztest_vbap_02-posnr.

    " related to parallel processing
    "--- Messages returned to behavior layer (reported-so_header)
    TYPES: BEGIN OF ty_item_msg,
             vbeln    TYPE vbeln,
             msgno    TYPE symsgno, " optional: which message number you want to show
             severity TYPE if_abap_behv_message=>t_severity,
             v1       TYPE string,
             v2       TYPE string,
           END OF ty_item_msg,
           tt_item_msg TYPE STANDARD TABLE OF ty_item_msg WITH EMPTY KEY.

    METHODS do_parallel_processing
      IMPORTING it_so_header TYPE tt_ztest_vbak02
      EXPORTING ev_has_red   TYPE abap_bool
                ev_summary   TYPE string
                et_item_msgs TYPE tt_item_msg.

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

  METHOD get_last_sales_doc_num.
    rv_sales_doc_num = lcl_salesorder_buffer=>get_instance( )->get_last_sales_doc_num_buffer( ).
  ENDMETHOD.

  METHOD create_so_header.
    ro_msg = lcl_salesorder_buffer=>get_instance( )->create_so_header_buffer( it_so_header = it_so_header ).
  ENDMETHOD.

  METHOD update_so_header.
    lcl_salesorder_buffer=>get_instance( )->update_so_header_buffer( it_so_header         = it_so_header
                                                                     it_so_header_control = it_so_header_control ).
  ENDMETHOD.

  METHOD block_sales_order_buffer.
    lcl_salesorder_buffer=>get_instance( )->block_sales_order_buffer( it_so_header    = it_so_header
                                                                      iv_block_status = iv_block_status ).
  ENDMETHOD.

  METHOD unblock_sales_order_buffer.
    lcl_salesorder_buffer=>get_instance( )->unblock_sales_order_buffer( it_so_header    = it_so_header
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

  METHOD do_parallel_processing.
    lcl_salesorder_buffer=>get_instance( )->do_parallel_processing( EXPORTING it_so_header = it_so_header
                                                                    IMPORTING ev_has_red   = ev_has_red
                                                                              ev_summary   = ev_summary
                                                                              et_item_msgs = et_item_msgs ).
  ENDMETHOD.
ENDCLASS.
