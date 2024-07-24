CLASS lhc_SalesHead_M_01 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    CONSTANTS cv_block_st_for_admin_approval TYPE faksk VALUE '99'.
    CONSTANTS cv_unblck_st_for_admin_approvl TYPE faksk VALUE ' '.
    CONSTANTS cv_unblocked_status            TYPE faksk VALUE ''.

    METHODS block_order FOR MODIFY
      IMPORTING keys FOR ACTION SalesHead_M_01~blockOrder RESULT result.

    METHODS unblock_order FOR MODIFY
      IMPORTING keys FOR ACTION SalesHead_M_01~unblockOrder RESULT result.

    " ( features : instance ) in behavior def
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR SalesHead_M_01 RESULT result.

ENDCLASS.


CLASS lhc_SalesHead_M_01 IMPLEMENTATION.
  METHOD block_order.
    LOOP AT keys REFERENCE INTO DATA(key).
      MODIFY ENTITY IN LOCAL MODE zahk_i_sales_header_m_01
             UPDATE FIELDS ( block_status )
             WITH VALUE #( ( sales_doc_num = key->%key-sales_doc_num
                             block_status  = cv_block_st_for_admin_approval ) )
             REPORTED reported
             FAILED failed.

      IF failed IS INITIAL.
        READ ENTITY IN LOCAL MODE zahk_i_sales_header_m_01
             ALL FIELDS WITH
             VALUE #( ( sales_doc_num = key->%key-sales_doc_num ) )
             RESULT DATA(lt_result).

        result = VALUE #( FOR <ls_result> IN lt_result
                          ( sales_doc_num        = key->%key-sales_doc_num
                            %param-sales_doc_num = <ls_result>-sales_doc_num
                            %param-block_status  = <ls_result>-block_status ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD unblock_order.
    LOOP AT keys REFERENCE INTO DATA(key).
      MODIFY ENTITY IN LOCAL MODE zahk_i_sales_header_m_01
             UPDATE FIELDS ( block_status )
             WITH VALUE #( ( sales_doc_num = key->%key-sales_doc_num
                             block_status  = cv_unblck_st_for_admin_approvl ) )
             REPORTED reported
             FAILED failed.

      IF failed IS INITIAL.
        READ ENTITY IN LOCAL MODE zahk_i_sales_header_m_01
             ALL FIELDS WITH
             VALUE #( ( sales_doc_num = key->%key-sales_doc_num ) )
             RESULT DATA(lt_result).

        result = VALUE #( FOR <ls_result> IN lt_result
                          ( sales_doc_num        = key->%key-sales_doc_num
                            %param-sales_doc_num = <ls_result>-sales_doc_num
                            %param-block_status  = <ls_result>-block_status ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITY IN LOCAL MODE zahk_i_sales_header_m_01
         ALL FIELDS WITH
         VALUE #(  FOR <key> IN keys
                  ( sales_doc_num = <key>-%key-sales_doc_num ) )
         RESULT DATA(lt_result).

    " Dynamic Feature Control
    " -> what I basically do here is, based on the blocked status we allow the user to be able to do actions.
    " -> E.g -> if on UI the marked line has blocked status, which is '99', then the buttons 'Delete' and 'Edit' wont be clickable anymore on UI.
    result = VALUE #( FOR <ls_result> IN lt_result
                      ( %tky               = <ls_result>-sales_doc_num
                        %update            = COND #( WHEN <ls_result>-block_status = cv_unblocked_status
                                                     THEN if_abap_behv=>fc-f-unrestricted
                                                     ELSE if_abap_behv=>fc-f-read_only )
                        %delete            = COND #( WHEN <ls_result>-block_status = cv_unblocked_status
                                                     THEN if_abap_behv=>fc-o-enabled
                                                     ELSE if_abap_behv=>fc-o-disabled )
                        %assoc-_SItem_M_01 = COND #( WHEN <ls_result>-block_status = cv_unblocked_status
                                                     THEN if_abap_behv=>fc-o-enabled
                                                     ELSE if_abap_behv=>fc-o-disabled ) ) ).
    " %tky stands for transactional key. In non-draft use cases , %tky contains the same value as %key which is the key of the related entity.
    " In draft-enabled use cases, %tky will automatically contain the is_draft indicator.
  ENDMETHOD.
ENDCLASS.


CLASS lcl_additional_save DEFINITION INHERITING FROM cl_abap_behavior_saver.
  " https://help.sap.com/docs/abap-cloud/abap-rap/implementing-additional-save

  " lets say you a have requirement as following :
  " -> if a line is marked and edited one or a few fields of it, based on that, if edited fields have proper values
  " you want to call a Function Module / Method / BAPI etc to do another operation in parallel. (such as creating a sales order in parallel)
  " -> In such scenarios its the place where you put your codes.

  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.
ENDCLASS.


CLASS lcl_additional_save IMPLEMENTATION.
  METHOD save_modified.
    " -> these are tables
    " CREATE-EntityName
    " UPDATE-EntityName
    " DELETE-EntityName

    DATA lt_item         TYPE z_tt_sales_item_01.
    DATA lv_status_subrc TYPE i.

    IF create-saleshead_m_01 IS NOT INITIAL.
      " means -> Creation has been made

      " Call BAPI, FM or CRUD on Database Tables etc.
    ENDIF.

    " -- UNMANAGED SAVE --
    " -> if we would want a specific logic while creating a record on item level
    " CREATE would not have the table SalesItem_M_01.
    " to do so, in behavior def. :
    " 1. persistent table commented out
    " 2. added 'with unmanaged save'
    " https://help.sap.com/docs/abap-cloud/abap-rap/unmanaged-save
    " https://help.sap.com/docs/abap-cloud/abap-rap/integrating-unmanaged-save-in-managed-business-objects
    IF create-salesitem_m_01 IS NOT INITIAL.

      lt_item = VALUE #( FOR ls_sales_item IN create-salesitem_m_01
                         ( vbeln                  = ls_sales_item-sales_doc_num
                           posnr                  = ls_sales_item-item_position
                           waerk                  = 'EUR'
                           arktx                  = ls_sales_item-mat_desc
                           matnr                  = ls_sales_item-mat_num
                           kpein                  = ls_sales_item-quantity
                           netpr                  = ls_sales_item-unit_cost
                           netwr                  = ls_sales_item-quantity * ls_sales_item-unit_cost
                           kmein                  = 'PC'
                           last_changed_timestamp = ls_sales_item-last_changed_on ) ).

      CALL FUNCTION 'Z_CREATE_ITEM_01'
        EXPORTING item   = lt_item
        IMPORTING status = lv_status_subrc.

      IF lv_status_subrc <> 0.
        " Error Message to display on UI
        LOOP AT lt_item INTO DATA(ls_item).
          APPEND VALUE #( sales_doc_num = ls_item-vbeln
                          item_position = ls_item-posnr
                          %msg          = new_message( id       = 'ZAHK_RAP_MANAGED_01' " message class
                                                       number   = '000'
                                                       severity = if_abap_behv_message=>severity-error
*                                                       v1       =
*                                                       v2       =
*                                                       v3       =
*                                                       v4       =
                                          ) ) TO reported-salesitem_m_01. " Messages to display on UI passed by to REPORTED

        ENDLOOP.
      ENDIF.
    ENDIF.

    IF update-saleshead_m_01 IS NOT INITIAL.
      " means -> Update has been made

      " Call BAPI, FM or CRUD on Database Tables etc.
    ENDIF.

    IF delete-saleshead_m_01 IS NOT INITIAL.
      " means -> Deletion has been made

      " Call BAPI, FM or CRUD on Database Tables etc.
    ENDIF.
  ENDMETHOD.
ENDCLASS.


CLASS lhc_salesitem_m_01 DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS newPriceTotal FOR DETERMINE ON MODIFY
      IMPORTING keys FOR SalesItem_M_01~newPriceTotal.
    METHODS checkNegativityPriceQty FOR VALIDATE ON SAVE
      IMPORTING keys FOR SalesItem_M_01~checkNegativityPriceQty.

ENDCLASS.

CLASS lhc_salesitem_m_01 IMPLEMENTATION.

  METHOD newPriceTotal.
  ENDMETHOD.

  METHOD checkNegativityPriceQty.
  ENDMETHOD.

ENDCLASS.
