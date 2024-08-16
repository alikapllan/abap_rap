CLASS lhc_SO_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE SO_Header.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE SO_Header.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE SO_Header.

    METHODS read FOR READ
      IMPORTING keys FOR READ SO_Header RESULT result.

    METHODS rba_Sitem_m_02 FOR READ
      IMPORTING keys_rba FOR READ SO_Header\_Sitem_m_02 FULL result_requested RESULT result LINK association_links.

    METHODS cba_Sitem_m_02 FOR MODIFY
      IMPORTING entities_cba FOR CREATE SO_Header\_Sitem_m_02.

ENDCLASS.

CLASS lhc_SO_Header IMPLEMENTATION.
  METHOD create.
    DATA ls_so_header TYPE ztest_vbak_02.
    DATA lt_so_header TYPE STANDARD TABLE OF ztest_vbak_02.

    DATA(lv_latest_sales_doc_num) = zcl_salesorder_operation_u_02=>get_instance( )->get_last_sales_doc_num( ).

    GET TIME STAMP FIELD DATA(lv_timestamp).

    LOOP AT entities REFERENCE INTO DATA(lr_entity).
      CLEAR ls_so_header.

      ls_so_header-vbeln = CONV vbeln( CONV i( lv_latest_sales_doc_num + 1 ) ).

      ls_so_header = CORRESPONDING #( lr_entity->* MAPPING
                                      faksk = block_status
                                      vtweg = sales_dist
                                      spart = sales_div
                                      vkorg = sales_org ).

      ls_so_header-netwr                  = 0.
      ls_so_header-waerk                  = 'USD'.
      ls_so_header-ernam                  = sy-uname.
      ls_so_header-erdat                  = sy-datum.
      ls_so_header-last_changed_timestamp = lv_timestamp.

      INSERT ls_so_header INTO TABLE lt_so_header.
    ENDLOOP.

    zcl_salesorder_operation_u_02=>get_instance( )->create_so_header( it_so_header = lt_so_header ).
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
    DATA lt_so_header TYPE STANDARD TABLE OF ztest_vbak_02.

    LOOP AT keys INTO DATA(ls_key).
      INSERT VALUE ztest_vbak_02( vbeln = ls_key-sales_doc_num ) INTO TABLE lt_so_header.
    ENDLOOP.

    zcl_salesorder_operation_u_02=>get_instance( )->delete_so_header( it_so_header = lt_so_header ).
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Sitem_m_02.
  ENDMETHOD.

  METHOD cba_Sitem_m_02.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_SO_Item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE SO_Item.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE SO_Item.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE SO_Item.

    METHODS read FOR READ
      IMPORTING keys FOR READ SO_Item RESULT result.

    METHODS rba_Sheader_m_02 FOR READ
      IMPORTING keys_rba FOR READ SO_Item\_Sheader_m_02 FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_SO_Item IMPLEMENTATION.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Sheader_m_02.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZAHK_I_SALES_HEADER_M_02 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZAHK_I_SALES_HEADER_M_02 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    " This method gets triggered anytime at any SQL specific changes like update, create, delete by Framework
    zcl_salesorder_operation_u_02=>get_instance( )->save_so_header( ).
  ENDMETHOD.

  METHOD cleanup.
    " -> This cleanup method gets triggered at the very at the end of all steps by Framework.
    " -> So no need to call this method explicitly in the save method after the operation.
    zcl_salesorder_operation_u_02=>get_instance( )->cleanup( ).
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
