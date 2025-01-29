*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_local_events DEFINITION INHERITING FROM cl_abap_behavior_event_handler.
  PRIVATE SECTION.
    METHODS log_blocked_sales_docs FOR ENTITY EVENT it_blocked_sales_docs FOR SalesHead_M_01~LogBlockedSalesDoc.

    CONSTANTS cv_block_st_for_admin_approval TYPE faksk VALUE '99'.
ENDCLASS.


CLASS lcl_local_events IMPLEMENTATION.
  METHOD log_blocked_sales_docs.
    LOOP AT it_blocked_sales_docs REFERENCE INTO DATA(ir_blocked_sales_doc).

      IF ir_blocked_sales_doc->blockedStatus = cv_block_st_for_admin_approval.
        MODIFY zahk_blocked_sal FROM @( VALUE #( salesdocno        = ir_blocked_sales_doc->%key-sales_doc_num
                                                 createdby         = ir_blocked_sales_doc->createdBy
                                                 blockedstatus     = ir_blocked_sales_doc->blockedStatus
                                                 blockedstatustext = ir_blocked_sales_doc->blockedStatusText
                                                 blockedon         = ir_blocked_sales_doc->blockedOn ) ).
      ELSE. " Sales Order Unblocked -> delete entries from table
        DELETE FROM zahk_blocked_sal WHERE salesdocno = ir_blocked_sales_doc->%key-sales_doc_num.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
