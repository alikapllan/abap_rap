CLASS zcl_rap_request_calc_exit DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit.
    INTERFACES if_sadl_exit_calc_element_read.
ENDCLASS.


CLASS zcl_rap_request_calc_exit IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA lt_req TYPE STANDARD TABLE OF zc_Request WITH EMPTY KEY.

    lt_req = CORRESPONDING #( it_original_data ).

    LOOP AT lt_req ASSIGNING FIELD-SYMBOL(<req>).
      " Simple rule: hidden = ( status <> 103 )
      <req>-CancelReasonHidden = xsdbool( <req>-Status <> '103' ).
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_req ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    " No need to implement it as Status is always being sent by the projection view
  ENDMETHOD.
ENDCLASS.
