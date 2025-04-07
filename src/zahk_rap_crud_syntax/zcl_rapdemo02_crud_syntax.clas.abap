CLASS zcl_rapdemo02_crud_syntax DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS sample_create.
    METHODS sample_read.
    METHODS sample_update.
    METHODS sample_delete.
ENDCLASS.


CLASS zcl_rapdemo02_crud_syntax IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
*    sample_create( ).
    sample_read( ).
*    sample_update( ).
*    sample_delete( ).
  ENDMETHOD.

  METHOD sample_create.
    GET TIME STAMP FIELD DATA(lv_timestamp).

    MODIFY ENTITY Zahk_I_userinfo02_m_02
           CREATE FIELDS ( Email FirstName LastName IsAdmin LastChanged )
           WITH
           VALUE #( ( Email       = 'mail@demo.com'
                      FirstName   = 'Alex'
                      LastName    = 'De Souza'
                      IsAdmin     = 'No'
                      LastChanged = lv_timestamp ) )
           REPORTED DATA(reported)
           FAILED DATA(failed).

    MODIFY ENTITIES OF Zahk_I_userinfo02_m_02
           ENTITY Zahk_I_userinfo02_m_02
           CREATE
           SET FIELDS WITH
           VALUE #( (
*                      %cid =
                      Email       = 'mail@demo.com'
                      FirstName   = 'Alex'
                      LastName    = 'De Souza'
                      IsAdmin     = 'No'
                      LastChanged = lv_timestamp ) )
           REPORTED reported
           FAILED failed.


    DATA lt_userinfo02 TYPE TABLE FOR CREATE Zahk_I_userinfo02_m_02.
    " ..
    " .. Preprocess of filling lt_userinfo02
    " ..
    MODIFY ENTITIES OF Zahk_I_userinfo02_m_02 IN LOCAL MODE
           ENTITY Zahk_I_userinfo02_m_02
           CREATE FROM lt_userinfo02
           FAILED DATA(ls_failed)
           MAPPED DATA(ls_mapped)
           REPORTED DATA(ls_reported).

    " After create -> Commit needed
    COMMIT ENTITIES
           RESPONSE OF Zahk_I_userinfo02_m_02
           FAILED   DATA(failed_commit)
           REPORTED DATA(reported_commit).
  ENDMETHOD.

  METHOD sample_delete.
    MODIFY ENTITY Zahk_I_userinfo02_m_02
           DELETE FROM
           VALUE #( ( Email = 'mail@demo.com' ) )
           REPORTED DATA(reported)
           FAILED DATA(failed).

    MODIFY ENTITIES OF Zahk_I_userinfo02_m_02
           ENTITY Zahk_I_userinfo02_m_02
           DELETE FROM
           VALUE #( ( Email = 'mail@demo.com' ) )
           REPORTED reported
           FAILED   failed.

    DATA lt_userinfo02 TYPE TABLE FOR DELETE Zahk_I_userinfo02_m_02.
    " ..
    " .. Preprocess of filling lt_userinfo02
    " ..
    MODIFY ENTITIES OF Zahk_I_userinfo02_m_02 IN LOCAL MODE
           ENTITY Zahk_I_userinfo02_m_02
           DELETE FROM lt_userinfo02
           FAILED DATA(ls_failed)
           MAPPED DATA(ls_mapped)
           REPORTED DATA(ls_reported).

    " After delete -> Commit needed
    COMMIT ENTITIES
           RESPONSE OF Zahk_I_userinfo02_m_02
           FAILED   DATA(failed_commit)
           REPORTED DATA(reported_commit).
  ENDMETHOD.

  METHOD sample_read.
    READ ENTITY Zahk_I_userinfo02_m_02
         ALL FIELDS
         WITH
         VALUE #( ( Email = 'warummacheichdas@gmail.com' )
                  ( Email = 'ihatesap@gmail.com' ) )
         RESULT DATA(lt_userinfo).

    " Specifying certain fields
    READ ENTITY Zahk_I_userinfo02_m_02
         FIELDS ( FirstName LastName )
         WITH
         VALUE #( ( Email = 'warummacheichdas@gmail.com' )
                  ( Email = 'ihatesap@gmail.com' ) )
         RESULT   DATA(lt_userinfo_some_fields)
         REPORTED DATA(reported) " to show messages to user in frontend
         FAILED   DATA(failed).

    " Dynamic read
    DATA lt_read_userinfo        TYPE TABLE FOR READ IMPORT Zahk_I_userinfo02_m_02.
    DATA lt_op_tab               TYPE abp_behv_retrievals_tab.
    DATA lt_read_userinfo_result TYPE TABLE FOR READ RESULT Zahk_I_userinfo02_m_02.

    lt_read_userinfo = VALUE #( ( %key-Email = 'warummacheichdas@gmail.com'
                                  " here marking fields that you wanna read
                                  %control   = VALUE #( FirstName = if_abap_behv=>mk-on
                                                        LastName  = if_abap_behv=>mk-on
                                                        FullName  = if_abap_behv=>mk-on
                                                        IsAdmin   = if_abap_behv=>mk-on ) ) ).

    lt_op_tab = VALUE #( entity_name = 'ZAHK_I_USERINFO02_M_02'
                         ( op        = if_abap_behv=>op-r-read
                           instances = REF #( lt_read_userinfo )
                           " read fields come in
                           results   = REF #( lt_read_userinfo_result ) ) ).

    READ ENTITIES OPERATIONS lt_op_tab FAILED DATA(read_failed).

    IF lines( lt_op_tab ) > 0 AND read_failed IS INITIAL.
      DATA(lt_result) = lt_op_tab[ 1 ]-results.
    ENDIF.
  ENDMETHOD.

  METHOD sample_update.
*    MODIFY ENTITY Zahk_I_userinfo02_m_02
*           UPDATE FIELDS ( FirstName LastName )
*           WITH
*           VALUE #( ( Email     = 'warummacheichdas@gmail.com'
*                      FirstName = 'Keine'
*                      LastName  = 'Ahnung' ) )
*           REPORTED DATA(reported)
*           FAILED   DATA(failed).

    MODIFY ENTITY Zahk_I_userinfo02_m_02
           UPDATE FROM
           VALUE #( ( Email              = 'warummacheichdas@gmail.com'
                      FirstName          = 'Keine'
                      LastName           = 'Ahnung'
                      %control-FirstName = if_abap_behv=>mk-on       " '01' indicates this field can be changed if provided
                      %control-LastName  = if_abap_behv=>mk-off  ) ) " '00' indicates this field cannot be changed even if provided
           REPORTED DATA(reported)
           FAILED   DATA(failed).

    MODIFY ENTITIES OF Zahk_I_userinfo02_m_02
           ENTITY Zahk_I_userinfo02_m_02
           UPDATE FROM
           VALUE #( ( Email              = 'warummacheichdas@gmail.com'
                      FirstName          = 'Keine'
                      LastName           = 'Ahnung'
                      %control-FirstName = if_abap_behv=>mk-on       " '01' indicates this field can be changed if provided
                      %control-LastName  = if_abap_behv=>mk-off  ) ) " '00' indicates this field cannot be changed even if provided
           REPORTED reported
           FAILED   failed.

    DATA lt_userinfo02 TYPE TABLE FOR UPDATE Zahk_I_userinfo02_m_02.
    " ..
    " .. Preprocess of filling lt_userinfo02
    " ..
    MODIFY ENTITIES OF Zahk_I_userinfo02_m_02 IN LOCAL MODE
           ENTITY Zahk_I_userinfo02_m_02
           UPDATE FROM lt_userinfo02
           FAILED DATA(ls_failed)
           MAPPED DATA(ls_mapped)
           REPORTED DATA(ls_reported).

    " After update -> Commit needed
    COMMIT ENTITIES
           RESPONSE OF Zahk_I_userinfo02_m_02
           FAILED   DATA(failed_commit)
           REPORTED DATA(reported_commit).
  ENDMETHOD.
ENDCLASS.
