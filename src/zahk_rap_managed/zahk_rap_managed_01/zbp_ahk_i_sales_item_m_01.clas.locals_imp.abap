CLASS lhc_salesitem_m_01 DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS new_price_total FOR DETERMINE ON MODIFY
      IMPORTING keys FOR SalesItem_M_01~newPriceTotal.

    METHODS check_negativity_price_qty FOR VALIDATE ON SAVE
      IMPORTING keys FOR SalesItem_M_01~checkNegativityPriceQty.

ENDCLASS.


CLASS lhc_salesitem_m_01 IMPLEMENTATION.
  METHOD new_price_total.
    DATA lv_updated_docno   TYPE ztest_vbap_01-vbeln.
    DATA lv_new_total_price TYPE ztest_vbap_01-netwr VALUE 0.

    READ ENTITIES OF zahk_i_sales_header_m_01 IN LOCAL MODE
         ENTITY SalesHead_M_01 BY \_SItem_M_01
*         FROM VALUE #( FOR key IN keys -> this leads to a not proper read
         ALL FIELDS WITH VALUE #( FOR key IN keys " -> ALL FIELDS WITH VALUE enables us to read all correct values
                       ( sales_doc_num = key-%tky-sales_doc_num ) )
         RESULT DATA(lt_sales_item).

    IF lt_sales_item IS NOT INITIAL.
      lv_updated_docno = lt_sales_item[ 1 ]-sales_doc_num.

      LOOP AT lt_sales_item INTO DATA(ls_item).
        " last total price + new price of the newly added item
        lv_new_total_price += ( ls_item-quantity * ls_item-unit_cost ).
      ENDLOOP.
    ENDIF.

    MODIFY ENTITY IN LOCAL MODE zahk_i_sales_header_m_01
           UPDATE FIELDS ( total_cost ) WITH
           VALUE #( ( sales_doc_num = lv_updated_docno
                      total_cost    = lv_new_total_price ) )
           REPORTED DATA(reported_update)
           FAILED DATA(failed_update).

    IF failed_update IS NOT INITIAL.
      " Throw error message
    ENDIF.
  ENDMETHOD.

  METHOD check_negativity_price_qty.
    READ ENTITIES OF zahk_i_sales_header_m_01 IN LOCAL MODE
         ENTITY SalesHead_M_01 BY \_SItem_M_01
         FROM VALUE #( FOR key IN keys
                       ( sales_doc_num = key-%tky-sales_doc_num ) )
         RESULT DATA(lt_sales_item).

    LOOP AT lt_sales_item INTO DATA(ls_item).
      LOOP AT keys REFERENCE INTO DATA(lr_key).

        IF lr_key->item_position = ls_item-item_position.
          " check negativity
          IF ls_item-unit_cost < 0 OR ls_item-quantity < 0.
            APPEND VALUE #( sales_doc_num = lr_key->%tky-sales_doc_num
                            item_position = lr_key->%tky-item_position ) TO failed-salesitem_m_01.

            APPEND VALUE #( sales_doc_num = lr_key->%tky-sales_doc_num
                            item_position = lr_key->%tky-item_position
                            %msg          = new_message( id       = 'ZAHK_RAP_MANAGED_01'
                                                         number   = '001'
                                                         severity = if_abap_behv_message=>severity-error
                                                         v1       = lr_key->%tky-item_position
                                            ) ) TO reported-salesitem_m_01.
          ENDIF.
        ENDIF.

      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
