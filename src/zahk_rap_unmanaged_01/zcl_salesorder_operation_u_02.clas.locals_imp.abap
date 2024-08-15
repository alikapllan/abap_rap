*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_salesorder_buffer DEFINITION FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES t_ztest_vbak02  TYPE ztest_vbak_02.
    TYPES tt_ztest_vbak02 TYPE STANDARD TABLE OF t_ztest_vbak02.

    DATA gt_so_header_update_buffer TYPE STANDARD TABLE OF ztest_vbak_02.
    DATA gt_so_header_delete_buffer TYPE STANDARD TABLE OF ztest_vbak_02.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO lcl_salesorder_buffer.

    METHODS delete_so_header_buffer IMPORTING it_so_header TYPE tt_ztest_vbak02.
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
    " filling buffer table. -> Main Business Logic is done within the save method of class which inherits cl_abap_behavior_saver.
    gt_so_header_delete_buffer = CORRESPONDING #( it_so_header ).
  ENDMETHOD.

  METHOD save_so_header_buffer.
    " Business Logic of Save comes here

    " SQL Logic comes here
    IF lines( gt_so_header_delete_buffer ) > 0.
      DELETE ztest_vbak_02 FROM TABLE @( CORRESPONDING #( gt_so_header_delete_buffer ) ).
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gt_so_header_update_buffer,
           gt_so_header_delete_buffer.
  ENDMETHOD.
ENDCLASS.
