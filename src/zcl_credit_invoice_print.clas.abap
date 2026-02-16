CLASS zcl_credit_invoice_print DEFINITION
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



CLASS ZCL_CREDIT_INVOICE_PRINT IMPLEMENTATION.


 METHOD read_posts .

 DATA  lv_xml TYPE STRING.

 lv_xml =
|<Form>                                                              |   &&
|<bdyMain>       |   &&
|<CompanyCode></CompanyCode>       |   &&
|<Add_Line1></Add_Line1>       |   &&
|<Comp_Name></Comp_Name>       |   &&
|<PLANT></PLANT>       |   &&
|<Invoice_NO></Invoice_NO>       |   &&
|<Invoice_Date></Invoice_Date>       |   &&
|<Cust_Invo_No></Cust_Invo_No>       |   &&
|<Orignal_ref_no></Orignal_ref_no>       |   &&
|<INR></INR>       |   &&
|<Cust_Po_Date></Cust_Po_Date>       |   &&
|<Contact_Persone></Contact_Persone>       |   &&
|<Email_ID></Email_ID>       |   &&
|<Contact_No></Contact_No>       |   &&
|<Vendore_Code></Vendore_Code>       |   &&
|<Place_of_Supply></Place_of_Supply>       |   &&
|<Orignal_ref_Date></Orignal_ref_Date>       |   &&
|<frm_all_billto>       |   &&
|<Cust_Code></Cust_Code>       |   &&
|<Cust_Name></Cust_Name>       |   &&
|<B_add_line1></B_add_line1>       |   &&
|<B_add_line2></B_add_line2>       |   &&
|<B_add_line3></B_add_line3>       |   &&
|<State></State>       |   &&
|<Pan_No></Pan_No>       |   &&
|<GSTIN_No></GSTIN_No>       |   &&
|</frm_all_billto>       |   &&
|<frm_all_Shippedto>       |   &&
|<Ship_to_no></Ship_to_no>       |   &&
|<Ship_to_name></Ship_to_name>       |   &&
|<S_add_line1></S_add_line1>       |   &&
|<S_add_line2></S_add_line2>       |   &&
|<S_add_line3></S_add_line3>       |   &&
|<State></State>       |   &&
|<State_Code></State_Code>       |   &&
|<Pan_No></Pan_No>       |   &&
|<GSTIN_No></GSTIN_No>       |   &&
|</frm_all_Shippedto>       |   &&
|<Table1>       | .

 lv_xml =   lv_xml &&
|<fields>                                  |   &&
|<sr_no_field></sr_no_field>     |   &&
|<prod_desc></prod_desc>     |   &&
|<HSN_field></HSN_field>     |   &&
|<Quantity_field></Quantity_field>     |   &&
|<Rate_field></Rate_field>     |   &&
|<Discount_field></Discount_field>     |   &&
|<Total_field></Total_field>     |   &&
|<Total_tax_field></Total_tax_field>     |   &&
|<CGST_field></CGST_field>     |   &&
|<SGST_field></SGST_field>     |   &&
|<IGST_Filed></IGST_Filed>     |   &&
|</fields>     |   .


 lv_xml =   lv_xml &&
|</Table1>                                                                               |     &&
|<Payment_term></Payment_term>     |     &&
|<Sub_Total></Sub_Total>     |     &&
|<CGST_amount></CGST_amount>     |     &&
|<SGST_Amount></SGST_Amount>     |     &&
|<IGST_Amount></IGST_Amount>     |     &&
|<TCS_Amount></TCS_Amount>     |     &&
|<Invoice_Total></Invoice_Total>     |     &&
|<frm_bottom_overall_inner>     |     &&
|<remark></remark>     |     &&
|<Account_No></Account_No>     |     &&
|<Account_No></Account_No>     |     &&
|<Comp_head_txt></Comp_head_txt>     |     &&
|</frm_bottom_overall_inner>     |     &&
|</bdyMain>     |     &&
|</Form>     |     .

 ENDMETHOD.
ENDCLASS.
