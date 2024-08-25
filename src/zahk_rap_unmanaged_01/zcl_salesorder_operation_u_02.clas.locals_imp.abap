*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_salesorder_buffer DEFINITION FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES t_ztest_vbak02  TYPE ztest_vbak_02.
    TYPES tt_ztest_vbak02 TYPE STANDARD TABLE OF t_ztest_vbak02.

    TYPES t_ztest_vbap02  TYPE ztest_vbap_02.
    TYPES tt_ztest_vbap02 TYPE STANDARD TABLE OF t_ztest_vbap02 WITH EMPTY KEY.

    " Header
    DATA gt_so_header_update_buffer TYPE STANDARD TABLE OF ztest_vbak_02.
    DATA gt_so_header_delete_buffer TYPE STANDARD TABLE OF ztest_vbak_02.
    DATA gt_so_header_create_buffer TYPE STANDARD TABLE OF ztest_vbak_02.
    " Item
    DATA gt_so_item_delete_buffer   TYPE STANDARD TABLE OF ztest_vbap_02.
    DATA gt_so_item_create_buffer   TYPE STANDARD TABLE OF ztest_vbap_02.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO lcl_salesorder_buffer.

    METHODS delete_so_header_buffer IMPORTING it_so_header TYPE tt_ztest_vbak02.
    METHODS create_so_header_buffer IMPORTING it_so_header TYPE tt_ztest_vbak02
                                    RETURNING VALUE(ro_msg) TYPE REF TO if_abap_behv_message.
    METHODS update_so_header_buffer IMPORTING it_so_header         TYPE tt_ztest_vbak02
                                              it_so_header_control TYPE zif_sales_order_structure=>tt_so_control.
    METHODS save_so_header_buffer.
    METHODS cleanup_buffer.

    METHODS create_so_item_buffer IMPORTING it_so_item TYPE tt_ztest_vbap02.
    METHODS delete_so_item_buffer IMPORTING it_so_item TYPE tt_ztest_vbap02.

    METHODS get_last_sales_doc_num_buffer RETURNING VALUE(rv_sales_doc_num) TYPE vbeln.
    METHODS get_associated_items_buffer IMPORTING it_so_header TYPE tt_ztest_vbak02
                                 RETURNING VALUE(rt_sales_items) TYPE tt_ztest_vbap02.

    METHODS get_item_full_details_buffer IMPORTING it_so_items           TYPE tt_ztest_vbap02
                                         RETURNING VALUE(rt_sales_items) TYPE tt_ztest_vbap02.

    METHODS block_or_unlock_so_buffer IMPORTING it_so_header    TYPE tt_ztest_vbak02
                                                iv_block_status TYPE ztest_vbak_02-faksk.

    METHODS get_item_new_posnr_buffer IMPORTING iv_so_sales_doc_num      TYPE ztest_vbap_02-vbeln
                                      RETURNING VALUE(rv_new_item_posnr) TYPE ztest_vbap_02-posnr.

  PRIVATE SECTION.
    CLASS-DATA go_instance TYPE REF TO lcl_salesorder_buffer.

    METHODS get_associated_header IMPORTING it_so_item          TYPE tt_ztest_vbap02
                                  RETURNING VALUE(rs_so_header) TYPE t_ztest_vbak02.

    METHODS update_header_total_price IMPORTING it_so_item            TYPE tt_ztest_vbap02
                                                iv_create_flag        TYPE abap_bool OPTIONAL
                                                iv_delete_flag        TYPE abap_bool OPTIONAL.

    METHODS calculate_header_new_price IMPORTING is_so_header         TYPE t_ztest_vbak02
                                                 it_so_item           TYPE tt_ztest_vbap02
                                                 iv_create_flag       TYPE abap_bool OPTIONAL
                                                 iv_delete_flag       TYPE abap_bool OPTIONAL
                                       EXPORTING es_so_header_updated TYPE t_ztest_vbak02.
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

    " Item
    DATA(lt_sales_items) = get_associated_items_buffer( it_so_header = it_so_header ).
    gt_so_item_delete_buffer = lt_sales_items.
  ENDMETHOD.

  METHOD save_so_header_buffer.
    " Business Logic of Save comes here

    " SQL Logic comes here
    IF lines( gt_so_header_delete_buffer ) > 0.
      DELETE ztest_vbak_02 FROM TABLE @( CORRESPONDING #( gt_so_header_delete_buffer ) ).
    ENDIF.

    IF lines( gt_so_item_delete_buffer ) > 0.
      DELETE ztest_vbap_02 FROM TABLE @( gt_so_item_delete_buffer ).
    ENDIF.

    IF lines( gt_so_header_create_buffer ) > 0.
      INSERT ztest_vbak_02 FROM TABLE @( CORRESPONDING #( gt_so_header_create_buffer ) ).
    ENDIF.

    IF lines( gt_so_header_update_buffer ) > 0.
      UPDATE ztest_vbak_02 FROM TABLE @( gt_so_header_update_buffer ).
    ENDIF.

    IF lines( gt_so_item_create_buffer ) > 0.
      INSERT ztest_vbap_02 FROM TABLE @( CORRESPONDING #( gt_so_item_create_buffer ) ).
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gt_so_header_update_buffer,
           gt_so_header_delete_buffer,
           gt_so_header_create_buffer,
           gt_so_item_delete_buffer,
           gt_so_item_create_buffer.
  ENDMETHOD.

  METHOD get_last_sales_doc_num_buffer.
    SELECT FROM ztest_vbak_02
      FIELDS MAX( vbeln )
      INTO @rv_sales_doc_num.
  ENDMETHOD.

  METHOD create_so_header_buffer.
    LOOP AT it_so_header INTO DATA(ls_so_header).
      IF    ls_so_header-vkorg < 0
         OR ls_so_header-vtweg < 0
         OR ls_so_header-spart < 0.

        " .. Message Handling within Operation Class (outside of the Behavior Implementation)
        ro_msg = zcl_ahk_abap_behv_msg=>get_instance( )->new_message( id       = 'ZAHK_RAP_UNM_01'
                                                                      number   = '001'
                                                                      severity = if_abap_behv_message=>severity-error
                                                                      v1       = 'Creating Header'
                                                                      v2       = 'Negative Values not allowed at Sales Org/Dist/Div' ).
        RETURN.
      ENDIF.
    ENDLOOP.

    gt_so_header_create_buffer = CORRESPONDING #( it_so_header ).
  ENDMETHOD.

  METHOD get_associated_items_buffer.
    SELECT FROM ztest_vbap_02
      FIELDS *
      FOR ALL ENTRIES IN @it_so_header
      WHERE vbeln = @it_so_header-vbeln
      INTO TABLE @DATA(lt_sales_items).

    IF sy-subrc = 0.
       rt_sales_items = lt_sales_items.
    ENDIF.
  ENDMETHOD.

  METHOD get_item_new_posnr_buffer.
    SELECT FROM ztest_vbap_02
      FIELDS MAX( posnr )
      WHERE vbeln = @iv_so_sales_doc_num
      INTO @DATA(lv_last_item_posnr).

    IF sy-subrc = 0.
      rv_new_item_posnr = lv_last_item_posnr + 10.
    ENDIF.
  ENDMETHOD.

  METHOD update_so_header_buffer.
    " .. Consider both %control table and fill the missing data which don't need to be updated
    " from DB table.

    DATA lv_flag_control   TYPE i VALUE 2. " because in interface in first place there is vbeln_id which is used as an indicator, not flag.

    DATA lr_structure_desc TYPE REF TO cl_abap_structdescr.
    DATA ls_column_name    TYPE LINE OF abap_component_tab.
    DATA lt_column_names   TYPE abap_component_tab.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    SELECT FROM ztest_vbak_02
      FIELDS *
      FOR ALL ENTRIES IN @it_so_header
      WHERE vbeln = @it_so_header-vbeln
      INTO TABLE @DATA(lt_so_h_data_all).

    LOOP AT lt_so_h_data_all ASSIGNING FIELD-SYMBOL(<lfs_so_header>).

      ASSIGN it_so_header[ vbeln = <lfs_so_header>-vbeln ] TO FIELD-SYMBOL(<lfs_sent_so_header>).

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      ASSIGN it_so_header_control[ vbeln_id = <lfs_sent_so_header>-vbeln ] TO FIELD-SYMBOL(<lfs_so_header_control>).

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF lines( lt_column_names ) = 0.
        " .. Get all column names and save into internal table
        lr_structure_desc = CAST #( cl_abap_typedescr=>describe_by_data( <lfs_so_header_control> ) ).
        lt_column_names = lr_structure_desc->get_components( ).
      ENDIF.

      DO.
        " .. reading of all fields of the structure horizontally.
        ASSIGN COMPONENT lv_flag_control OF STRUCTURE <lfs_so_header_control> TO FIELD-SYMBOL(<lfs_v_flag>).

        " .. means -> last field of structure is read. End of the structure is reached.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.

        IF <lfs_v_flag> = '01' OR <lfs_v_flag> = '1'. " if change applied to field
          " .. getting the updated column name
          ls_column_name = VALUE #( lt_column_names[ lv_flag_control ] ).

          ASSIGN COMPONENT ls_column_name-name OF STRUCTURE <lfs_so_header> TO FIELD-SYMBOL(<lfs_old_value>).
          ASSIGN COMPONENT ls_column_name-name OF STRUCTURE <lfs_sent_so_header> TO FIELD-SYMBOL(<lfs_new_value_updated>).

          " .. replacing the old value with the new one in the column where the change has been applied.
          " E.g. waerk from 'USD' to 'EUR'
          <lfs_old_value> = <lfs_new_value_updated>.

          <lfs_so_header>-last_changed_timestamp = lv_timestamp.
        ENDIF.

        lv_flag_control += 1.
      ENDDO.

      INSERT <lfs_so_header> INTO TABLE gt_so_header_update_buffer.

    ENDLOOP.
  ENDMETHOD.

  METHOD block_or_unlock_so_buffer.
    " .. Get related Sales Orders
    SELECT FROM ztest_vbak_02
      FIELDS *
      FOR ALL ENTRIES IN @it_so_header
      WHERE vbeln = @it_so_header-vbeln
      INTO TABLE @DATA(lt_so_header_to_block).

    " .. Assign them blocked or unblocked status
    LOOP AT lt_so_header_to_block REFERENCE INTO DATA(lr_so_header_to_block).
      lr_so_header_to_block->*-faksk = iv_block_status.

      INSERT lr_so_header_to_block->* INTO TABLE gt_so_header_update_buffer. " as we are updating block status field
    ENDLOOP.
  ENDMETHOD.

  METHOD create_so_item_buffer.
    gt_so_item_create_buffer = CORRESPONDING #( it_so_item ).

    " .. The new total price in item needs to be taken into account in header.
    " .. Total price of all items = total price in header
    update_header_total_price( it_so_item = it_so_item
                               iv_create_flag = abap_true ).
  ENDMETHOD.

  METHOD update_header_total_price.
    DATA(ls_so_header) = get_associated_header( it_so_item = it_so_item ).
    calculate_header_new_price( EXPORTING is_so_header         = ls_so_header
                                          it_so_item           = it_so_item
                                          iv_create_flag       = iv_create_flag
                                          iv_delete_flag       = iv_delete_flag
                                IMPORTING es_so_header_updated = DATA(ls_so_header_updated) ).

    INSERT ls_so_header_updated INTO TABLE gt_so_header_update_buffer.
  ENDMETHOD.

  METHOD get_associated_header.
    SELECT FROM ztest_vbak_02
      FIELDS *
      FOR ALL ENTRIES IN @it_so_item
      WHERE vbeln = @it_so_item-vbeln
      INTO TABLE @DATA(lt_so_header).

    IF sy-subrc = 0.
      rs_so_header = lt_so_header[ 1 ].
    ENDIF.
  ENDMETHOD.

  METHOD calculate_header_new_price.
    DATA lt_so_header                TYPE STANDARD TABLE OF ztest_vbak_02.
    DATA lv_total_price_items        TYPE ztest_vbak_02-netwr.
    DATA lv_total_price_marked_items TYPE ztest_vbak_02-netwr.

    es_so_header_updated = is_so_header.

    CLEAR: lt_so_header,
           lv_total_price_items,
           lv_total_price_marked_items.

    INSERT es_so_header_updated INTO TABLE lt_so_header.

    DATA(lt_so_items_all_data) = get_associated_items_buffer( it_so_header = lt_so_header ).

    LOOP AT lt_so_items_all_data INTO DATA(ls_so_item).
      lv_total_price_items += ls_so_item-netwr.
    ENDLOOP.

    LOOP AT it_so_item INTO DATA(ls_so_item_marked).
      lv_total_price_marked_items += ls_so_item_marked-netwr.
    ENDLOOP.

    IF iv_delete_flag = abap_true.
      es_so_header_updated-netwr = ( lv_total_price_items - lv_total_price_marked_items ).
    ENDIF.

    IF iv_create_flag = abap_true.
      es_so_header_updated-netwr = ( lv_total_price_items + lv_total_price_marked_items ).
    ENDIF.
  ENDMETHOD.

  METHOD delete_so_item_buffer.
    gt_so_item_delete_buffer = it_so_item.

    " .. The new total price in item needs to be taken into account in header.
    " .. Total price of all items = total price in header
    update_header_total_price( it_so_item     = get_item_full_details_buffer( it_so_items = it_so_item )
                               iv_delete_flag = abap_true ).
  ENDMETHOD.

  METHOD get_item_full_details_buffer.
    SELECT FROM ztest_vbap_02
      FIELDS *
      FOR ALL ENTRIES IN @it_so_items
      WHERE vbeln = @it_so_items-vbeln AND
            posnr = @it_so_items-posnr
      INTO TABLE @DATA(lt_sales_items).

    IF sy-subrc = 0.
       rt_sales_items = lt_sales_items.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
