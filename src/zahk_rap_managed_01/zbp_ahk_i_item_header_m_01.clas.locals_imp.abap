CLASS lhc_salesitem_m_01 DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS new_price_total FOR DETERMINE ON MODIFY
      IMPORTING keys FOR SalesItem_M_01~newPriceTotal.

    METHODS check_negativity_price_qty FOR VALIDATE ON SAVE
      IMPORTING keys FOR SalesItem_M_01~checkNegativityPriceQty.

ENDCLASS.


CLASS lhc_salesitem_m_01 IMPLEMENTATION.
  METHOD new_price_total.
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
