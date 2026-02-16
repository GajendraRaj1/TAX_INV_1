CLASS zcl_debit_invoice_print DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS :
      read_posts
        IMPORTING VALUE(INVOICE_FROM) TYPE STRING
        RETURNING VALUE(result12)     TYPE string
                        RAISING   cx_static_check .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEBIT_INVOICE_PRINT IMPLEMENTATION.


 METHOD read_posts .

 DATA  lv_xml TYPE STRING.

 lv_xml = lv_xml &&
|<Form>                                           |   &&
|<bdyMain>     |   &&
|<CompanyCode></CompanyCode>     |   &&
|<Comp_Name></Comp_Name>     |   &&
|<plant></plant>     |   &&
|<YY1_ENTRYTIME_BDH></YY1_ENTRYTIME_BDH>     |   &&
|<Invoice_No></Invoice_No>     |   &&
|<Invoice_Date></Invoice_Date>     |   &&
|<Eway_Bill_No></Eway_Bill_No>     |   &&
|<INR_No></INR_No>     |   &&
|<docno/>     |   &&
|<gstinno/>     |   &&
|<Code128ABarcode1/>     |   &&
|<frm_all_billto>     |   &&
|<Comp_Name></Comp_Name>     |   &&
|<Addline_1></Addline_1>     |   &&
|<Addline_2></Addline_2>     |   &&
|<Addline_3></Addline_3>     |   &&
|<Addline_4></Addline_4>     |   &&
|<Addline_5></Addline_5>     |   &&
|<State></State>     |   &&
|<State_Code></State_Code>     |   &&
|<GSTIN_No></GSTIN_No>     |   &&
|<Pan_No></Pan_No>     |   &&
|</frm_all_billto>     |   &&
|<frm_all_ship_to>     |   &&
|<Ship_to_add></Ship_to_add>     |   &&
|<Ship_to_add1></Ship_to_add1>     |   &&
|<Ship_to_add2></Ship_to_add2>     |   &&
|<Ship_to_add3></Ship_to_add3>     |   &&
|<Ship_to_add4></Ship_to_add4>     |   &&
|<State_Code></State_Code>     |   &&
|<GSTIN_No></GSTIN_No>     |   &&
|</frm_all_ship_to>     |   &&
|<Export_Under></Export_Under>     |   &&
|<Unloading_Point></Unloading_Point>     |   &&
|<ImageField1/>     |   &&
|<DATE></DATE>     |   &&
|<EDI_FIELD></EDI_FIELD>     |   &&
|<VENDOR_CODE_FIELD></VENDOR_CODE_FIELD>     |   &&
|<INVOICE_N_FILED></INVOICE_N_FILED>     |   &&
|<INVOICE_DATE_FIELD></INVOICE_DATE_FIELD>     |   &&
|<PO_NO_FIELD></PO_NO_FIELD>     |   &&
|<LINE_ITEM_FIELD></LINE_ITEM_FIELD>     |   &&
|<RATE_FIELD></RATE_FIELD>     |   &&
|<ITEM_CODE_FIELD></ITEM_CODE_FIELD>     |   &&
|<HSN_CODE_FIELD></HSN_CODE_FIELD>     |   &&
|<INVOICE_QTY_FIELD></INVOICE_QTY_FIELD>     |   &&
|<BILL_AMOUNT_FIELD></BILL_AMOUNT_FIELD>     |   &&
|<PurchaseOrderByCustomer></PurchaseOrderByCustomer>         |  &&
|<YY1_POLineItemNumber_BDI></YY1_POLineItemNumber_BDI>    |  &&
|<YY1_customer_material_BDI></YY1_customer_material_BDI>    |  &&
|<Code128ABarcode2/>    |  .

 lv_xml = lv_xml &&
|<Row2>    |  &&
|<MOD_No></MOD_No>    |  &&
|<sap_code></sap_code>    |  &&
|<ITEM_CODE_FIELD></ITEM_CODE_FIELD>    |  &&
|<qty_field></qty_field>    |  &&
|<Unit_field></Unit_field>    |  &&
|<packing_field></packing_field>    |  &&
|<rate_field></rate_field>    |  &&
|<Total_field></Total_field>    |  &&
|</Row2>    |  .

 lv_xml = lv_xml &&
|<gst_in_words/>    |  &&
|<gst_taxes>    |  &&
|<grand_toal></grand_toal>    |  &&
|</gst_taxes>    |  &&
|<TextField2></TextField2>    |  &&
|<amenkmentno></amenkmentno>    |  &&
|<originalinvno></originalinvno>    |  &&
|<ogigiinvdate></ogigiinvdate>    |  &&
|<remark>Vale</remark>    |  &&
|</bdyMain>    |  &&
|</Form>    |  .


 ENDMETHOD.
ENDCLASS.
