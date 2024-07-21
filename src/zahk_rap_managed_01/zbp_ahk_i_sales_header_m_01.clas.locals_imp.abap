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
    " -> E.g -> if on UI the marked line has blocked status, which is '99', then the buttons 'Delete' and 'Edit wont be clickable anymore.
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
