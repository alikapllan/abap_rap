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

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO lcl_salesorder_buffer.

    METHODS delete_so_header_buffer IMPORTING it_so_header TYPE tt_ztest_vbak02.
    METHODS create_so_header_buffer IMPORTING it_so_header TYPE tt_ztest_vbak02.
    METHODS update_so_header_buffer IMPORTING it_so_header         TYPE tt_ztest_vbak02
                                              it_so_header_control TYPE zif_sales_order_structure=>tt_so_control.
    METHODS save_so_header_buffer.
    METHODS cleanup_buffer.
    METHODS get_last_sales_doc_num_buffer RETURNING VALUE(rv_sales_doc_num) TYPE vbeln.
    METHODS get_associated_items IMPORTING it_so_header TYPE tt_ztest_vbak02
                                 RETURNING VALUE(rt_sales_items) TYPE tt_ztest_vbap02.

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

    " Item
    DATA(lt_sales_items) = get_associated_items( it_so_header = it_so_header ).
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
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gt_so_header_update_buffer,
           gt_so_header_delete_buffer,
           gt_so_header_create_buffer,
           gt_so_item_delete_buffer.
  ENDMETHOD.

  METHOD get_last_sales_doc_num_buffer.
    SELECT FROM ztest_vbak_02
      FIELDS MAX( vbeln )
      INTO @rv_sales_doc_num.
  ENDMETHOD.

  METHOD create_so_header_buffer.
    gt_so_header_create_buffer = CORRESPONDING #( it_so_header ).
  ENDMETHOD.

  METHOD get_associated_items.
    SELECT FROM ztest_vbap_02
      FIELDS *
      FOR ALL ENTRIES IN @it_so_header
      WHERE vbeln = @it_so_header-vbeln
      INTO TABLE @DATA(lt_sales_items).

    IF sy-subrc = 0.
       rt_sales_items = lt_sales_items.
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

ENDCLASS.
