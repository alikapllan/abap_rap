INTERFACE zif_sales_order_structure
  PUBLIC.
  " %control

  " .. in our example it will be used to notice which fields are changed/provided while editing.

  " ..Structured component that is a component of many BDEF derived types.
  " ..It contains the names of all key and data fields of a RAP BO instance, which indicate flags.
  " ..For example, it is used to get information on which fields are provided or set a flag for which
  " fields are requested by RAP BO providers or RAP BO consumers respectively during the current EML request.
  " ..For this purpose, the value of each field in the %control structure is of type ABP_BEHV_FLAG.
  " ..For the value setting, you can use the structured constant mk of interface IF_ABAP_BEHV.
  " ..Note that the technical type is x length 1.
  " ..Example: If you want to read data from a RAP BO instance and particular non-key fields in %control are
  " set to if_abap_behv=>mk-off, the values of these fields are not returned in the result.

  " -- Source: https://github.com/SAP-samples/abap-cheat-sheets/blob/main/08_EML_ABAP_for_RAP.md

  TYPES: BEGIN OF ts_so_control,
           vbeln TYPE abp_behv_flag,
           faksk TYPE abp_behv_flag,
           vtweg TYPE abp_behv_flag,
           spart TYPE abp_behv_flag,
           vkorg TYPE abp_behv_flag,
           netwr TYPE abp_behv_flag,
           waerk TYPE abp_behv_flag,
           ernam TYPE abp_behv_flag,
           erdat TYPE abp_behv_flag,
         END OF ts_so_control.

  TYPES tt_so_control TYPE STANDARD TABLE OF ts_so_control.

ENDINTERFACE.
