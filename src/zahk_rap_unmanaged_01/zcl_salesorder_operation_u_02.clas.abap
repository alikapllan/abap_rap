CLASS zcl_salesorder_operation_u_02 DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_salesorder_operation_u_02.

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
ENDCLASS.
