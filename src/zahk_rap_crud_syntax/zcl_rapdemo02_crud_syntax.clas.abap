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
*    sample_read( ).
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

    " After update -> Commit needed
    COMMIT ENTITIES
           RESPONSE OF Zahk_I_userinfo02_m_02
           FAILED   DATA(failed_commit)
           REPORTED DATA(reported_commit).
  ENDMETHOD.
ENDCLASS.
