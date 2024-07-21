CLASS lhc_SalesHead_M_01 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    CONSTANTS cv_block_st_for_admin_approval TYPE faksk VALUE '99'.
    CONSTANTS cv_unblck_st_for_admin_approvl TYPE faksk VALUE ' '.

    METHODS block_order FOR MODIFY
      IMPORTING keys FOR ACTION SalesHead_M_01~blockOrder RESULT result.

    METHODS unblock_order FOR MODIFY
      IMPORTING keys FOR ACTION SalesHead_M_01~unblockOrder RESULT result.

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
ENDCLASS.
