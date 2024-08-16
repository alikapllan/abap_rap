CLASS zcl_salesorder_operation_u_02 DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES t_ztest_vbak02  TYPE ztest_vbak_02.
    TYPES tt_ztest_vbak02 TYPE STANDARD TABLE OF t_ztest_vbak02.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_salesorder_operation_u_02.

    METHODS delete_so_header IMPORTING it_so_header TYPE tt_ztest_vbak02.
    METHODS create_so_header IMPORTING it_so_header TYPE tt_ztest_vbak02.
    METHODS save_so_header.
    METHODS cleanup.
    METHODS get_last_sales_doc_num RETURNING VALUE(rv_sales_doc_num) TYPE vbeln.

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

ENDCLASS.
