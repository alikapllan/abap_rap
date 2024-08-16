*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_salesorder_buffer DEFINITION FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES t_ztest_vbak02  TYPE ztest_vbak_02.
    TYPES tt_ztest_vbak02 TYPE STANDARD TABLE OF t_ztest_vbak02.

    TYPES t_ztest_vbap02  TYPE ztest_vbap_02.
    TYPES tt_ztest_vbap02 TYPE STANDARD TABLE OF t_ztest_vbap02 WITH EMPTY KEY.

    " Header
    DATA gt_so_header_update_buffer TYPE STANDARD TABLE OF ztest_vbak_02.
    DATA gt_so_header_delete_buffer TYPE STANDARD TABLE OF ztest_vbak_02.
    DATA gt_so_header_create_buffer TYPE STANDARD TABLE OF ztest_vbak_02.
    " Item
    DATA gt_so_item_delete_buffer   TYPE STANDARD TABLE OF ztest_vbap_02.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO lcl_salesorder_buffer.

    METHODS delete_so_header_buffer IMPORTING it_so_header TYPE tt_ztest_vbak02.
    METHODS create_so_header_buffer IMPORTING it_so_header TYPE tt_ztest_vbak02.
    METHODS save_so_header_buffer.
    METHODS cleanup_buffer.
    METHODS get_last_sales_doc_num_buffer RETURNING VALUE(rv_sales_doc_num) TYPE vbeln.
    METHODS get_associated_items IMPORTING it_so_header TYPE tt_ztest_vbak02
                                 RETURNING VALUE(rt_sales_item_doc_nums) TYPE tt_ztest_vbap02.

  PRIVATE SECTION.
    CLASS-DATA go_instance TYPE REF TO lcl_salesorder_buffer.
ENDCLASS.


CLASS lcl_salesorder_buffer IMPLEMENTATION.
  METHOD get_instance.
    go_instance = COND #( WHEN go_instance IS BOUND
                          THEN go_instance
                          ELSE NEW #( ) ).

    ro_instance = go_instance.
  ENDMETHOD.

  METHOD delete_so_header_buffer.
    " filling buffer table. -> Main Business Logic is done within the save method of class which inherits cl_abap_behavior_saver.
    gt_so_header_delete_buffer = CORRESPONDING #( it_so_header ).

    " Item
    DATA(lt_sales_item_doc_num) = get_associated_items( it_so_header = it_so_header ).
    gt_so_item_delete_buffer = lt_sales_item_doc_num.
  ENDMETHOD.

  METHOD save_so_header_buffer.
    " Business Logic of Save comes here

    " SQL Logic comes here
    IF lines( gt_so_header_delete_buffer ) > 0.
      DELETE ztest_vbak_02 FROM TABLE @( CORRESPONDING #( gt_so_header_delete_buffer ) ).
    ENDIF.

    IF lines( gt_so_item_delete_buffer ) > 0.
      DELETE ztest_vbap_02 FROM TABLE @( gt_so_item_delete_buffer ).
    ENDIF.

    IF lines( gt_so_header_create_buffer ) > 0.
      INSERT ztest_vbak_02 FROM TABLE @( CORRESPONDING #( gt_so_header_create_buffer ) ).
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gt_so_header_update_buffer,
           gt_so_header_delete_buffer,
           gt_so_header_create_buffer,
           gt_so_item_delete_buffer.
  ENDMETHOD.

  METHOD get_last_sales_doc_num_buffer.
    SELECT FROM ztest_vbak_02
      FIELDS MAX( vbeln )
      INTO @rv_sales_doc_num.
  ENDMETHOD.

  METHOD create_so_header_buffer.
    gt_so_header_create_buffer = CORRESPONDING #( it_so_header ).
  ENDMETHOD.

  METHOD get_associated_items.
    SELECT FROM ztest_vbap_02
      FIELDS *
      FOR ALL ENTRIES IN @it_so_header
      WHERE vbeln = @it_so_header-vbeln
      INTO TABLE @DATA(lt_sales_item_doc_nums).

    IF sy-subrc = 0.
       rt_sales_item_doc_nums = lt_sales_item_doc_nums.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
