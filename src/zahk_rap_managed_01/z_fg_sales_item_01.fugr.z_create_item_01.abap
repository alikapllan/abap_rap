FUNCTION z_create_item_01.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ITEM) TYPE  Z_TT_SALES_ITEM_01
*"  EXPORTING
*"     VALUE(STATUS) TYPE  I
*"----------------------------------------------------------------------
  IF item IS NOT INITIAL.
    INSERT ztest_vbap_01 FROM TABLE @item.

    IF sy-subrc <> 0.
      status = 1. " Error
      RETURN.
    ENDIF.

    status = 0.
  ENDIF.
ENDFUNCTION.
