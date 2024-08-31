" .. Messages
" Inheritance from CX_ROOT gives implementation of GET_TEXT, GET_LONGTEXT

" -> lcl_abap_behv_msg from method new_message within cl_abap_behv implementation
CLASS zcl_ahk_abap_behv_msg DEFINITION
  PUBLIC
  INHERITING FROM cx_no_check FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES if_t100_message.
    INTERFACES if_t100_dyn_msg.
    INTERFACES if_abap_behv_message.

    ALIASES msgty FOR if_t100_dyn_msg~msgty.
    ALIASES msgv1 FOR if_t100_dyn_msg~msgv1.
    ALIASES msgv2 FOR if_t100_dyn_msg~msgv2.
    ALIASES msgv3 FOR if_t100_dyn_msg~msgv3.
    ALIASES msgv4 FOR if_t100_dyn_msg~msgv4.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_ahk_abap_behv_msg.

    " .. Copied from method new_message within cl_abap_behv definition
    METHODS new_message
      IMPORTING !id        TYPE symsgid
                !number    TYPE symsgno
                severity   TYPE if_abap_behv_message=>t_severity
                v1         TYPE simple OPTIONAL
                v2         TYPE simple OPTIONAL
                v3         TYPE simple OPTIONAL
                v4         TYPE simple OPTIONAL
      RETURNING VALUE(obj) TYPE REF TO if_abap_behv_message.

  PRIVATE SECTION.
    CLASS-DATA go_instance TYPE REF TO zcl_ahk_abap_behv_msg.

    METHODS constructor
      IMPORTING textid    LIKE if_t100_message=>t100key OPTIONAL
                !previous LIKE previous                 OPTIONAL
                msgty     TYPE symsgty                  OPTIONAL
                msgv1     TYPE simple                   OPTIONAL
                msgv2     TYPE simple                   OPTIONAL
                msgv3     TYPE simple                   OPTIONAL
                msgv4     TYPE simple                   OPTIONAL.
ENDCLASS.


CLASS zcl_ahk_abap_behv_msg IMPLEMENTATION.
  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).
    me->msgty = msgty.
    me->msgv1 = msgv1.
    me->msgv2 = msgv2.
    me->msgv3 = msgv3.
    me->msgv4 = msgv4.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.

  METHOD get_instance.
    go_instance = COND #( WHEN go_instance IS BOUND
                          THEN go_instance
                          ELSE NEW #( ) ).

    ro_instance = go_instance.
  ENDMETHOD.


  METHOD new_message.
    " .. Copied from method new_message within cl_abap_behv implementation

    CONSTANTS ms LIKE if_abap_behv_message=>severity VALUE if_abap_behv_message=>severity ##NO_TEXT.
    CONSTANTS mc LIKE if_abap_behv=>cause            VALUE if_abap_behv=>cause ##NO_TEXT.

    obj = NEW Zcl_ahk_abap_behv_msg( textid = VALUE #(
                                         msgid = id
                                         msgno = number
                                         attr1 = COND #( WHEN v1 IS NOT INITIAL THEN 'IF_T100_DYN_MSG~MSGV1' )
                                         attr2 = COND #( WHEN v2 IS NOT INITIAL THEN 'IF_T100_DYN_MSG~MSGV2' )
                                         attr3 = COND #( WHEN v3 IS NOT INITIAL THEN 'IF_T100_DYN_MSG~MSGV3' )
                                         attr4 = COND #( WHEN v4 IS NOT INITIAL THEN 'IF_T100_DYN_MSG~MSGV4' ) )
                                     msgty  = SWITCH #( severity
                                                        WHEN ms-error       THEN 'E'
                                                        WHEN ms-warning     THEN 'W'
                                                        WHEN ms-information THEN 'I'
                                                        WHEN ms-success     THEN 'S' )
                                     msgv1  = |{ v1 }|
                                     msgv2  = |{ v2 }|
                                     msgv3  = |{ v3 }|
                                     msgv4  = |{ v4 }| ).

    obj->m_severity = severity.
  ENDMETHOD.

ENDCLASS.
