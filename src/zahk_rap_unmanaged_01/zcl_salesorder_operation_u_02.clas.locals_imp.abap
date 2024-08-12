*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_salesorder_buffer DEFINITION FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    DATA gt_so_header_update_buffer TYPE STANDARD TABLE OF ztest_vbak_02.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO lcl_salesorder_buffer.

    METHODS delete_so_header_buffer.
    METHODS save_so_header_buffer.
    METHODS cleanup_buffer.

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
    " Business Logic of Delete comes here
  ENDMETHOD.

  METHOD save_so_header_buffer.
    " Business Logic of Save comes here
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR gt_so_header_update_buffer.
  ENDMETHOD.
ENDCLASS.
