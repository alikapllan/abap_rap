@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root CDS View Sales Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@VDM.viewType: #COMPOSITE
// this is called 'root' because a behaviour&service definition will be attached (UI)
// Top Level in the hierarchy
define root view entity ZAHK_I_SALES_HEADER_M_01
  as select from ZAHK_I_SALES_HEADER_01 // select from other CDS
  composition [0..*] of ZAHK_I_SALES_ITEM_M_01 as _SItem_M_01
{
  key sales_doc_num,
      date_created,
      person_created,
      sales_org,
      sales_dist,
      sales_div,
      @Semantics.amount.currencyCode: 'CostCurrency'
      total_cost,
      CostCurrency,
      block_status,
      case block_status
          when ' ' then 'OK'
          when '99' then 'Approval needed'
          else 'Blocked'
      end as block_status_msg,
      
      @Semantics.largeObject: { mimeType: 'mimetype',  
                                fileName: 'filename',  
                                contentDispositionPreference: #INLINE
                               // -> we can also specify what kind of files types are allowed to be uploaded.
                               // -> E.g. with the annonation below we would only allow excel uploads
                               // acceptableMimeTypes: [ 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ]
                              }
      attachment,
      filename,
      @Semantics.mimeType: true
      mimetype,
      
      
      last_changed_on,

      /* Associations */
      _SItem_M_01
}
