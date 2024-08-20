CLASS lhc_SO_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE SO_Header.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE SO_Header.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE SO_Header.

    METHODS read FOR READ " Etag Master Impl. done here
      IMPORTING keys FOR READ SO_Header RESULT result.

    METHODS rba_Sitem_m_02 FOR READ
      IMPORTING keys_rba FOR READ SO_Header\_Sitem_m_02 FULL result_requested RESULT result LINK association_links.

    METHODS cba_Sitem_m_02 FOR MODIFY " creating item triggers here. cba = create by association
      IMPORTING entities_cba FOR CREATE SO_Header\_Sitem_m_02.

    METHODS blockOrder FOR MODIFY
      IMPORTING keys FOR ACTION SO_Header~blockOrder RESULT result.

    METHODS unblockOrder FOR MODIFY
      IMPORTING keys FOR ACTION SO_Header~unblockOrder RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES " automatic created method for Instance Feature
      IMPORTING keys REQUEST requested_features FOR SO_Header RESULT result.

ENDCLASS.

CLASS lhc_SO_Header IMPLEMENTATION.
  METHOD create.
    DATA ls_so_header TYPE ztest_vbak_02.
    DATA lt_so_header TYPE STANDARD TABLE OF ztest_vbak_02.

    DATA(lv_latest_sales_doc_num) = zcl_salesorder_operation_u_02=>get_instance( )->get_last_sales_doc_num( ).

    GET TIME STAMP FIELD DATA(lv_timestamp).

    LOOP AT entities REFERENCE INTO DATA(lr_entity).
      CLEAR ls_so_header.

      ls_so_header = CORRESPONDING #( lr_entity->* MAPPING
                                      faksk = block_status
                                      vtweg = sales_dist
                                      spart = sales_div
                                      vkorg = sales_org ).

      ls_so_header-vbeln = CONV vbeln( CONV i( lv_latest_sales_doc_num + 1 ) ).
      CONDENSE ls_so_header-vbeln. " removing spaces

      ls_so_header-netwr                  = 0.
      ls_so_header-waerk                  = 'USD'.
      ls_so_header-ernam                  = sy-uname.
      ls_so_header-erdat                  = sy-datum.
      ls_so_header-last_changed_timestamp = lv_timestamp.

      INSERT ls_so_header INTO TABLE lt_so_header.
    ENDLOOP.

    DATA(lo_msg) = zcl_salesorder_operation_u_02=>get_instance( )->create_so_header( it_so_header = lt_so_header ).

    IF lo_msg IS BOUND.
      LOOP AT lt_so_header REFERENCE INTO DATA(lr_so_header).
        " .. Return the created error message from outside of the behav. implementation to the UI
        INSERT VALUE #( sales_doc_num = lr_so_header->*-vbeln
                        %msg          = lo_msg ) INTO TABLE reported-so_header.

        " .. Break RAP Save Mechanism
        INSERT VALUE #( sales_doc_num = lr_so_header->*-vbeln ) INTO TABLE failed-so_header.
      ENDLOOP.
    ELSE.
      " .. maybe throw a success message
    ENDIF.
  ENDMETHOD.

  METHOD update.
    DATA ls_so_header  TYPE ztest_vbak_02.
    DATA lt_so_header  TYPE STANDARD TABLE OF ztest_vbak_02.
    " ..!
    DATA ls_so_header_control TYPE zif_sales_order_structure=>ts_so_control.
    DATA lt_so_header_control TYPE zif_sales_order_structure=>tt_so_control.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    LOOP AT entities REFERENCE INTO DATA(lr_entity).
      CLEAR: ls_so_header,
             ls_so_header_control.

      ls_so_header = CORRESPONDING #( lr_entity->* MAPPING
                                      vbeln = sales_doc_num
                                      faksk = block_status
                                      vtweg = sales_dist
                                      spart = sales_div
                                      vkorg = sales_org
                                      netwr = total_cost
                                      waerk = cost_currency
                                      ernam = person_created
                                      erdat = date_created ).

      ls_so_header-last_changed_timestamp = lv_timestamp.

      INSERT ls_so_header INTO TABLE lt_so_header.

      " %control
      " .. changed fields take value '01'.
      ls_so_header_control = CORRESPONDING #( lr_entity->*-%control MAPPING
                                               vbeln = sales_doc_num
                                               faksk = block_status
                                               vtweg = sales_dist
                                               spart = sales_div
                                               vkorg = sales_org
                                               netwr = total_cost
                                               waerk = cost_currency
                                               ernam = person_created
                                               erdat = date_created ).

      ls_so_header_control-vbeln_id = ls_so_header-vbeln. " used in order to figure out to which sales doc changes are applied

      INSERT ls_so_header_control INTO TABLE lt_so_header_control.
    ENDLOOP.

    zcl_salesorder_operation_u_02=>get_instance( )->update_so_header( it_so_header         = lt_so_header
                                                                      it_so_header_control = lt_so_header_control ).
  ENDMETHOD.

  METHOD delete.
    DATA lt_so_header TYPE STANDARD TABLE OF ztest_vbak_02.

    LOOP AT keys INTO DATA(ls_key).
      INSERT VALUE ztest_vbak_02( vbeln = ls_key-sales_doc_num ) INTO TABLE lt_so_header.
    ENDLOOP.

    zcl_salesorder_operation_u_02=>get_instance( )->delete_so_header( it_so_header = lt_so_header ).
  ENDMETHOD.

  METHOD read.
    " .. what the framework at Etag does is, whenever an update is triggered, it will invoke this read
    " before the update and get the most recent copy of the table/data and compare / find the difference
    " and trigger the update process.
    SELECT FROM ztest_vbak_02
      FIELDS *
      FOR ALL ENTRIES IN @keys
      WHERE vbeln = @keys-sales_doc_num
      INTO TABLE @DATA(lt_so_headers).

    IF sy-subrc = 0.

      " .. Mapping is really important.
      " .. Even one field is missing you get the error :
      " 'our changes could not be saved. A more recent version is available.
      " To make changes to the latest version, please refresh the data. '
      result = CORRESPONDING #( lt_so_headers
                                MAPPING
                                sales_doc_num   = vbeln
                                block_status    = faksk
                                sales_dist      = vtweg
                                sales_div       = spart
                                sales_org       = vkorg
                                total_cost      = netwr
                                cost_currency   = waerk
                                person_created  = ernam
                                date_created    = erdat
                                last_changed_on = last_changed_timestamp ).
    ENDIF.
  ENDMETHOD.

  METHOD rba_Sitem_m_02.
  ENDMETHOD.

  METHOD cba_Sitem_m_02.
    " .. Create By Association

    DATA ls_so_item TYPE ztest_vbap_02.
    DATA lt_so_item TYPE STANDARD TABLE OF ztest_vbap_02 WITH EMPTY KEY.

    " .. Get new sales item position
    IF lines( entities_cba ) > 0.
      DATA(lv_new_so_item_posnr) = zcl_salesorder_operation_u_02=>get_instance(
                                    )->get_item_new_posnr( iv_so_sales_doc_num = entities_cba[ 1 ]-sales_doc_num  ).
    ENDIF.

    " .. Create a table of all items
    " .. Pass this to the operation
    LOOP AT entities_cba REFERENCE INTO DATA(lr_entity_cba).
      CLEAR ls_so_item.

      LOOP AT lr_entity_cba->*-%target REFERENCE INTO DATA(lr_entity_target).

      ls_so_item = CORRESPONDING #( lr_entity_target->*
                                    MAPPING
                                    " .. in the target we have only values which are provided in UI
                                    " .. as vbeln & posnr will be provided by us explicitly outside of the UI
                                    " both removed from here
                                    " .. total item cost is also calculated explicitly based on qty and unit cost
                                    waerk = cost_currency
                                    arktx = mat_desc
                                    matnr = mat_num
                                    kpein = quantity
                                    netpr = unit_cost
                                    kmein = unit ).

        " .. Check if values of qty and unit pr. are negative
        IF ls_so_item-netpr < 0 OR ls_so_item-kpein < 0.
          " .. REPORTED - Return Error message to the UI
          APPEND VALUE #( sales_doc_num = lr_entity_cba->*-sales_doc_num
                          %msg          = new_message( id       = 'ZAHK_RAP_UNM_01'
                                                       number   = '001'
                                                       severity = if_abap_behv_message=>severity-error
                                                       v1       = 'Item Creation'
                                                       v2       = 'Unit or Cost cannot be negative' ) ) TO reported-so_item.

          " .. FAILED - is also to be filled. Because when it is, the SAVE Mechanism in RAP wont be triggered.
          APPEND VALUE #( sales_doc_num = lr_entity_cba->*-sales_doc_num
                          item_position = lv_new_so_item_posnr ) TO failed-so_item.
        ENDIF.


      " .. Calculating price
      ls_so_item-netwr = ls_so_item-netpr * ls_so_item-kpein.

      ls_so_item-vbeln = lr_entity_cba->*-sales_doc_num. " here it will be taken from Header not UI.

      " .. Assigning new posnr
      ls_so_item-posnr = lv_new_so_item_posnr.

      INSERT ls_so_item INTO TABLE lt_so_item.

      ENDLOOP.

     ENDLOOP.

     zcl_salesorder_operation_u_02=>get_instance( )->create_so_item( it_so_item = lt_so_item ).
  ENDMETHOD.

  METHOD blockOrder.
    DATA lt_so_header TYPE STANDARD TABLE OF ztest_vbak_02.

    LOOP AT keys REFERENCE INTO DATA(lr_key).
      INSERT VALUE #( vbeln = lr_key->%key-sales_doc_num
                      faksk = zif_sales_order_structure=>c_blocked_status )
             INTO TABLE lt_so_header.
    ENDLOOP.

    zcl_salesorder_operation_u_02=>get_instance( )->block_or_unlock_so(
        it_so_header    = lt_so_header
        iv_block_status = zif_sales_order_structure=>c_blocked_status ).

    result = VALUE #( FOR s_so_header IN lt_so_header
                      ( sales_doc_num        = s_so_header-vbeln
                        %param-sales_doc_num = s_so_header-vbeln
                        %param-block_status  = s_so_header-faksk ) ).
  ENDMETHOD.

  METHOD unblockOrder.
    DATA lt_so_header TYPE STANDARD TABLE OF ztest_vbak_02.

    LOOP AT keys REFERENCE INTO DATA(lr_key).
      INSERT VALUE #( vbeln = lr_key->%key-sales_doc_num
                      faksk = zif_sales_order_structure=>c_unblocked_status )
             INTO TABLE lt_so_header.
    ENDLOOP.

    zcl_salesorder_operation_u_02=>get_instance( )->block_or_unlock_so(
        it_so_header    = lt_so_header
        iv_block_status = zif_sales_order_structure=>c_unblocked_status ).

    result = VALUE #( FOR s_so_header IN lt_so_header
                      ( sales_doc_num        = s_so_header-vbeln
                        %param-sales_doc_num = s_so_header-vbeln
                        %param-block_status  = s_so_header-faksk ) ).
  ENDMETHOD.

  METHOD get_instance_features.
    SELECT FROM ztest_vbak_02
      FIELDS *
      FOR ALL ENTRIES IN @keys
      WHERE vbeln = @keys-sales_doc_num
      INTO TABLE @DATA(lt_so_headers).

    " .. If sales order has unblocked status ' ', then is allowed to be edited/deleted

    " .. Loop would be also an option.
*    LOOP AT lt_so_headers INTO DATA(ls_so_header).
*      result = VALUE #(
*          BASE result
*          ( sales_doc_num      = ls_so_header-vbeln
*            %update            = COND #( WHEN ls_so_header-faksk = zif_sales_order_structure=>c_unblocked_status
*                                         THEN if_abap_behv=>fc-f-unrestricted
*                                         ELSE if_abap_behv=>fc-f-read_only )
*            %delete            = COND #( WHEN ls_so_header-faksk = zif_sales_order_structure=>c_unblocked_status
*                                         THEN if_abap_behv=>fc-f-unrestricted
*                                         ELSE if_abap_behv=>fc-f-read_only )
*            %assoc-_SItem_M_02 = COND #( WHEN ls_so_header-faksk = zif_sales_order_structure=>c_unblocked_status
*                                         THEN if_abap_behv=>fc-f-unrestricted
*                                         ELSE if_abap_behv=>fc-f-read_only ) ) ).
*    ENDLOOP.
*
    result = VALUE #(
        FOR s_so_header IN lt_so_headers
        ( sales_doc_num      = s_so_header-vbeln
          %update            = COND #( WHEN s_so_header-faksk = zif_sales_order_structure=>c_unblocked_status
                                       THEN if_abap_behv=>fc-f-unrestricted
                                       ELSE if_abap_behv=>fc-f-read_only )
          %delete            = COND #( WHEN s_so_header-faksk = zif_sales_order_structure=>c_unblocked_status
                                       THEN if_abap_behv=>fc-f-unrestricted
                                       ELSE if_abap_behv=>fc-f-read_only )
          %assoc-_SItem_M_02 = COND #( WHEN s_so_header-faksk = zif_sales_order_structure=>c_unblocked_status
                                       THEN if_abap_behv=>fc-f-unrestricted
                                       ELSE if_abap_behv=>fc-f-read_only ) ) ).
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
    " .. creating Item wont trigger here as item is created via association.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
    DATA ls_so_item TYPE ztest_vbap_02.
    DATA lt_so_item TYPE STANDARD TABLE OF ztest_vbap_02 WITH EMPTY KEY.

    LOOP AT keys REFERENCE INTO DATA(lr_key).
      ls_so_item = CORRESPONDING #( lr_key->*
                                    MAPPING
                                    vbeln = sales_doc_num
                                    posnr = item_position ).
      INSERT ls_so_item INTO TABLE lt_so_item.
    ENDLOOP.

    zcl_salesorder_operation_u_02=>get_instance( )->delete_so_item( lt_so_item ).
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
