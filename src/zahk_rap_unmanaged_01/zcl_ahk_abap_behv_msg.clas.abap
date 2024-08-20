" .. Messages
" Inheritance from CX_ROOT gives implementation of GET_TEXT, GET_LONGTEXT

" -> lcl_abap_behv_msg from method new_message within cl_abap_behv implementation
CLASS zcl_ahk_abap_behv_msg DEFINITION
  PUBLIC
  INHERITING FROM cx_no_check FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_message.
    INTERFACES if_t100_dyn_msg.
    INTERFACES if_abap_behv_message.

    ALIASES msgty FOR if_t100_dyn_msg~msgty.
    ALIASES msgv1 FOR if_t100_dyn_msg~msgv1.
    ALIASES msgv2 FOR if_t100_dyn_msg~msgv2.
    ALIASES msgv3 FOR if_t100_dyn_msg~msgv3.
    ALIASES msgv4 FOR if_t100_dyn_msg~msgv4.

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
ENDCLASS.
