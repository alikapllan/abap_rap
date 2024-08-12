CLASS zcl_salesorder_operation_u_02 DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_salesorder_operation_u_02.

    METHODS delete_so_header.
    METHODS save_so_header.
    METHODS cleanup.

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
    lcl_salesorder_buffer=>get_instance( )->delete_so_header_buffer( ).
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
ENDCLASS.
