CLASS zcl_tax_invoice_print DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  CLASS-METHODS :
      read_posts
        IMPORTING VALUE(INVOICE_FROM) TYPE I_BillingDocument-BillingDocument
        RETURNING VALUE(result12)     TYPE string
                        RAISING   cx_static_check .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TAX_INVOICE_PRINT IMPLEMENTATION.


 METHOD read_posts .

 DATA  lv_xml TYPE STRING.

SELECT * FROM I_BillingDocument WITH PRIVILEGED ACCESS as a
LEFT OUTER JOIN I_BillingDocumentItem WITH PRIVILEGED ACCESS as b ON ( b~BillingDocument = a~BillingDocument )
LEFT OUTER JOIN I_ProductPlantBasic WITH PRIVILEGED ACCESS as c ON ( c~Product = B~Product AND C~Plant = B~Plant )
LEFT OUTER JOIN I_SALESDOCUMENTITEM WITH PRIVILEGED ACCESS AS D ON ( d~SalesDocument = B~SalesDocument AND D~SalesDocumentItem = b~SalesDocumentItem )
WHERE a~BillingDocument = @invoice_from INTO  TABLE @DATA(IT).

READ TABLE IT INTO DATA(WA_HEAD) INDEX 1.


SELECT SINGLE * FROM I_IN_ElectronicDocInvoice WITH PRIVILEGED ACCESS AS A WHERE
ElectronicDocSourceKey = @wa_head-a-BillingDocument INTO @data(eway).


SELECT SINGLE * FROM I_SALESDOCUMENTITEM WITH PRIVILEGED ACCESS AS A WHERE
SalesDocument = @wa_head-b-SalesDocument AND SalesDocumentItem = @wa_head-b-SalesDocumentItem INTO @data(sodata).


SELECT SINGLE * FROM I_BillingDocumentItemPrcgElmnt WITH PRIVILEGED ACCESS AS A WHERE
BillingDocument = @wa_head-a-BillingDocument AND BillingDocumentItem = @WA_HEAD-b-BillingDocumentItem
AND ConditionType = 'PPR0' INTO @data(RATECONDI).


   SELECT SINGLE creationdate, billtoparty, shiptoparty FROM i_billingdocumentitem
    WHERE billingdocument = @wa_head-a-BillingDocument
    INTO @DATA(lv_creationdt).


    SELECT SINGLE * FROM i_businesspartner
    WHERE businesspartner = @lv_creationdt-shiptoparty
    INTO @DATA(lv_consignee_name).
*end
    SELECT SINGLE * FROM i_businesspartneraddresstp_3
    WHERE businesspartner = @lv_creationdt-shiptoparty
    INTO @DATA(lv_consignee).

    SELECT SINGLE * FROM i_customer WITH PRIVILEGED ACCESS AS A
    LEFT OUTER JOIN ZI_Address_2  WITH PRIVILEGED ACCESS as c ON ( c~AddressID = a~AddressID )
   LEFT OUTER JOIN I_RegionText   WITH PRIVILEGED ACCESS as f ON  ( f~Region = c~Region AND f~Country = c~Country AND f~language = 'E' )
LEFT OUTER JOIN i_countrytext   WITH PRIVILEGED ACCESS as e ON  ( e~Country = c~Country AND e~language = 'E' )
    WHERE customer = @lv_creationdt-shiptoparty
    INTO @DATA(lv_mob).

    SELECT SINGLE customerfullname FROM i_customer
    WHERE customer = @lv_creationdt-billtoparty
     INTO @DATA(lv_custadd).

    SELECT SINGLE * FROM i_businesspartner
    WHERE businesspartner = @lv_creationdt-billtoparty
    INTO @DATA(lv_cust_name).
*end
    SELECT SINGLE * FROM i_businesspartneraddresstp_3
    WHERE businesspartner = @lv_creationdt-billtoparty
    INTO @DATA(lv_cust).

   SELECT SINGLE * FROM i_customer as a
   LEFT OUTER JOIN ZI_Address_2  WITH PRIVILEGED ACCESS as c ON ( c~AddressID = a~AddressID )
   LEFT OUTER JOIN I_RegionText   WITH PRIVILEGED ACCESS as f ON  ( f~Region = c~Region AND f~Country = c~Country AND f~language = 'E' )
   LEFT OUTER JOIN i_countrytext   WITH PRIVILEGED ACCESS as e ON  ( e~Country = c~Country AND e~language = 'E' )
   WHERE customer = @lv_creationdt-BillToParty
   INTO @DATA(lv_mobcus).

DATA(BUYERADD) = lv_cust-PostalCode && lv_cust-CityName && lv_cust-Region .
DATA(BUYERTEL) = 'Tel No. : ' && lv_mobcus-A-telephonenumber1 .
DATA(BUYERphn) = 'Fax No. : ' && lv_mobcus-A-telephonenumber1 .


DATA(CONSIGADD) = lv_consignee-PostalCode && lv_consignee-CityName && lv_consignee-Region .
DATA(CONSIGTEL) = 'Tel No. :  ' && lv_mob-A-telephonenumber1 .
DATA(CONSIGphn) = 'Fax No. :  ' && lv_mob-A-telephonenumber1 .




data(lv_xml1) =
|<Form>|   .

 lv_xml =  lv_xml &&
|<bdyMain>         |     &&
|<CompanyCode>PUNE POLYMERS PVT.LTD. </CompanyCode>         |     &&
|<plant>{ WA_HEAD-b-Plant }</plant>         |     &&
|<Invoice_No>{ WA_HEAD-b-BillingDocument }</Invoice_No>         |     &&
|<LR_NO>{ WA_HEAD-a-YY1_LRNumber_BDH }</LR_NO>         |     &&
|<Invoice_Date>{ WA_HEAD-b-BillingDocumentDate }</Invoice_Date>         |     &&
|<Transporter_Name>{ WA_HEAD-a-YY1_TransporterName_BDH }</Transporter_Name>         |     &&
|<Eway_Bill_No>{ eway-IN_EDocEInvcEWbillNmbr }</Eway_Bill_No>         |     &&
|<YY1_VehicleNo1_BDH>{ WA_HEAD-a-YY1_VechileNumber_BDH }</YY1_VehicleNo1_BDH>         |     &&
|<YY1_ENTRYTIME_BDH></YY1_ENTRYTIME_BDH>         |     &&
|<INR_No>{ eway-IN_ElectronicDocInvcRefNmbr }</INR_No>         |     &&
|<Bill_Doc_No/>         |     &&
|<Eway_No/>         |     &&


|<frm_all_billto>         |     &&
|<Comp_Name>{ lv_cust_name-businesspartnerfullname }</Comp_Name>         |     &&
|<Addline_1>{ lv_cust-StreetName }</Addline_1>         |     &&
|<Addline_2>{ BUYERADD }</Addline_2>         |     &&
|<Addline_3>{ lv_mobcus-e-CountryName }</Addline_3>         |     &&
|<Addline_4>{ BUYERTEL }</Addline_4>         |     &&
|<Addline_5>{ BUYERphn }</Addline_5>         |     &&
|<State>{ lv_mobcus-f-RegionName }</State>         |     &&
|<State_Code>{ lv_mobcus-c-Region }</State_Code>         |     &&
|<GSTIN_No>{ lv_mobcus-a-TaxNumber3 }</GSTIN_No>         |     &&
|<Pan_No>{ lv_mobcus-a-TaxNumber3+2(10) }</Pan_No>         |     &&
|</frm_all_billto>         |     &&


|<frm_all_ship_to>         |     &&
|<Ship_to_add>{ lv_consignee_name-businesspartnerfullname }</Ship_to_add>         |     &&
|<Ship_to_add1>{ lv_consignee-StreetName }</Ship_to_add1>         |     &&
|<Ship_to_add2>{ CONSIGADD } { lv_mob-e-CountryName }</Ship_to_add2>         |     &&
|<Ship_to_add3>{ CONSIGTEL }</Ship_to_add3>         |     &&
|<Ship_to_add4>{ CONSIGphn }</Ship_to_add4>         |     &&
|<State>{ lv_mob-f-RegionName }</State>         |     &&
|<State_Code>{ lv_mob-c-Region }</State_Code>         |     &&
|<GSTIN_No>{ lv_mob-a-TaxNumber3 }</GSTIN_No>         |     &&
|</frm_all_ship_to>         |     &&

|<frm_BArcode>         |     &&
|<Export_Under></Export_Under>         |     &&
|<Unloading_Point></Unloading_Point>         |     &&
|<ImageField1/>         |     &&
|</frm_BArcode>         |     &&
|<YY1_PODATE_BDH></YY1_PODATE_BDH>         |     &&
|<YY1_EDINO_BDH></YY1_EDINO_BDH>         |     &&
|<VENDOR_CODE_FIELD></VENDOR_CODE_FIELD>         |     &&
|<INVOICE_N_FILED>{ WA_HEAD-b-BillingDocument }</INVOICE_N_FILED>         |     &&
|<INVOICE_DATE_FIELD>{ WA_HEAD-b-BillingDocumentDate }</INVOICE_DATE_FIELD>         |     &&
|<PO_NO_FIELD></PO_NO_FIELD>         |     &&
|<LINE_ITEM_FIELD></LINE_ITEM_FIELD>         |     &&
|<HSN_CODE_FIELD>{ WA_HEAD-C-ConsumptionTaxCtrlCode }</HSN_CODE_FIELD>         |     &&
|<INVOICE_QTY_FIELD>{ WA_HEAD-B-BillingQuantity }</INVOICE_QTY_FIELD>         |     &&
|<BILL_AMOUNT_FIELD>{ WA_HEAD-B-Subtotal5Amount }</BILL_AMOUNT_FIELD>         |     &&
|<Rate_Amortization>{ RATECONDI-ConditionRateValue }</Rate_Amortization>         |     &&
|<PO_Item/>         |     &&
|<customer_material/>         |     &&
|<Tot_net_amount/>         |     &&
|<EDI_No/>         |     &&
|<Puchorf_by_Cust/>         |     &&
|<Table3>         |     .


LOOP AT IT INTO DATA(WA_IT) .
clear : RATECONDI .
data transaction_value TYPE p DECIMALS 2.
SELECT SINGLE * FROM I_BillingDocumentItemPrcgElmnt WITH PRIVILEGED ACCESS AS A WHERE
BillingDocument = @WA_IT-a-BillingDocument AND BillingDocumentItem = @WA_IT-b-BillingDocumentItem
AND ConditionType = 'PPR0' INTO @RATECONDI.

transaction_value = transaction_value + wa_it-b-NetAmount.
 lv_xml =  lv_xml &&
|<Row2>                                    |   &&
|<SrNo></SrNo>    |   &&
|<ITEM_CODE_FIELD>{ wa_it-d-MaterialByCustomer }</ITEM_CODE_FIELD>    |   &&
|<sap_code>{ wa_it-b-Material }</sap_code>    |   &&
|<MOD_No></MOD_No>    |   &&
|<Quantity>{ wa_it-b-BillingQuantity }</Quantity>    |   &&
|<UNIT>{ wa_it-b-BillingQuantityUnit }</UNIT>    |   &&
|<Pack></Pack>    |   &&
|<Net>{ RATECONDI-ConditionRateValue }</Net>    |   &&
|<Amt>{ wa_it-b-NetAmount }</Amt>    |   &&
|</Row2>    |   .

ENDLOOP.

SELECT SINGLE * FROM I_BillingDocumentItemPrcgElmnt WITH PRIVILEGED ACCESS AS A WHERE
BillingDocument = @wa_head-a-BillingDocument AND BillingDocumentItem = @WA_HEAD-b-BillingDocumentItem
AND ConditionType = 'IGST' INTO @data(igst).
DATA GSTRATEIGST TYPE P DECIMALS 2.
GSTRATEIGST = igst-ConditionRateValue.

SELECT SINGLE * FROM I_BillingDocumentItemPrcgElmnt WITH PRIVILEGED ACCESS AS A WHERE
BillingDocument = @wa_head-a-BillingDocument AND BillingDocumentItem = @WA_HEAD-b-BillingDocumentItem
AND ConditionType = 'CGST' INTO @data(sgst).
DATA GSTRATESGST TYPE P DECIMALS 2.
GSTRATESGST = sgst-ConditionRateValue.

SELECT SINGLE * FROM I_BillingDocumentItemPrcgElmnt WITH PRIVILEGED ACCESS AS A WHERE
BillingDocument = @wa_head-a-BillingDocument AND BillingDocumentItem = @WA_HEAD-b-BillingDocumentItem
AND ( ConditionType = 'JTC1' OR ConditionType = 'JTC2' ) INTO @data(TCS).
DATA GSTRATETCS TYPE P DECIMALS 2.
GSTRATETCS = TCS-ConditionRateValue.


 lv_xml =  lv_xml &&
|</Table3>                                          |    &&
|<gst_in_words/>      |    &&
|<gst_taxes>      |    &&
|<transaction_value>{ transaction_value }</transaction_value>      |    &&
|<transportcost></transportcost>      |    &&
|<IGST></IGST>      |    &&
|<igst_per>{ GSTRATEIGST }</igst_per>      |    &&
|<igst_toal>{ IGST-ConditionAmount }</igst_toal>      |    &&
|<CGST></CGST>      |    &&
|<cgst_per>{ GSTRATESGST }</cgst_per>      |    &&
|<cgst_toal>{ SGST-ConditionAmount }</cgst_toal>      |    &&
|<SGST></SGST>      |    &&
|<sgst_per>{ GSTRATESGST }</sgst_per>      |    &&
|<sgst_toal>{ SGST-ConditionAmount }</sgst_toal>      |    &&
|<TCS></TCS>      |    &&
|<tcs_per>{ GSTRATETCS }</tcs_per>      |    &&
|<tcs_toal>{ TCS-ConditionAmount }</tcs_toal>      |    &&
|<Grand_Total></Grand_Total>      |    &&
|<grand_toal>{ WA_HEAD-b-Subtotal5Amount }</grand_toal>      |    &&
|</gst_taxes>      |    &&
|</bdyMain>      |  .

data(lv_xml3) =  lv_xml.
do 2 TIMES .
CONCATENATE lv_xml3 lv_xml  INTO lv_xml3.
ENDDO.

 data(lv_xml2) =
|</Form>|  .

CONCATENATE lv_xml1 lv_xml3 lv_xml2 INTO DATA(lv_xml_fin).

  CALL METHOD zcl_adobe_print=>adobe(
       EXPORTING
         xml  = lv_xml_fin
         form_name = 'TAX_INVOICE_PRINT'
       RECEIVING
         result   = result12 ).


*<bdyMain>
*<CompanyCode>Mirum est</CompanyCode>
*<plant>Experieris non Dianam magis montibus quam Minervam inerare.</plant>
*<Invoice_No>Licebit auctore</Invoice_No>
*<LR_NO>Proinde</LR_NO>
*<Invoice_Date>20040606T101010</Invoice_Date>
*<Transporter_Name>Am undique</Transporter_Name>
*<Eway_Bill_No>Ad retia sedebam</Eway_Bill_No>
*<YY1_VehicleNo1_BDH>Vale</YY1_VehicleNo1_BDH>
*<YY1_ENTRYTIME_BDH>Ego ille</YY1_ENTRYTIME_BDH>
*<INR_No>Mirum est ut animus agitatione motuque corporis excitetut.</INR_No>
*<Bill_Doc_No/>
*<Eway_No/>
*<frm_all_billto>
*<Comp_Name>Si manu vacuas</Comp_Name>
*<Addline_1>Apros tres et quidem</Addline_1>
*<Addline_2>Mirum est</Addline_2>
*<Addline_3>Licebit auctore</Addline_3>
*<Addline_4>Proinde</Addline_4>
*<Addline_5>Am undique</Addline_5>
*<State>Ad retia sedebam</State>
*<State_Code>Vale</State_Code>
*<GSTIN_No>Ego ille</GSTIN_No>
*<Pan_No>Si manu vacuas</Pan_No>
*</frm_all_billto>
*<frm_all_ship_to>
*<Ship_to_add>Apros tres et quidem</Ship_to_add>
*<Ship_to_add1>Mirum est</Ship_to_add1>
*<Ship_to_add2>Licebit auctore</Ship_to_add2>
*<Ship_to_add3>Proinde</Ship_to_add3>
*<Ship_to_add4>Am undique</Ship_to_add4>
*<State>Ad retia sedebam</State>
*<State_Code>Vale</State_Code>
*<GSTIN_No>Ego ille</GSTIN_No>
*</frm_all_ship_to>
*<frm_BArcode>
*<Export_Under>Si manu vacuas</Export_Under>
*<Unloading_Point>Apros tres et quidem</Unloading_Point>
*<ImageField1/>
*</frm_BArcode>
*<YY1_PODATE_BDH>20040606T101010</YY1_PODATE_BDH>
*<YY1_EDINO_BDH>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</YY1_EDINO_BDH>
*<VENDOR_CODE_FIELD>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</VENDOR_CODE_FIELD>
*<INVOICE_N_FILED>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</INVOICE_N_FILED>
*<INVOICE_DATE_FIELD>06-06-2004</INVOICE_DATE_FIELD>
*<PO_NO_FIELD>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</PO_NO_FIELD>
*<LINE_ITEM_FIELD>Experieris non Dianam magis montibus quam Minervam inerare.</LINE_ITEM_FIELD>
*<HSN_CODE_FIELD>Mirum est ut animus agitatione motuque corporis excitetut.</HSN_CODE_FIELD>
*<INVOICE_QTY_FIELD>5.6</INVOICE_QTY_FIELD>
*<BILL_AMOUNT_FIELD>6.3</BILL_AMOUNT_FIELD>
*<Rate_Amortization>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</Rate_Amortization>
*<PO_Item/>
*<customer_material/>
*<Tot_net_amount/>
*<EDI_No/>
*<Puchorf_by_Cust/>
*<Table3>
*<Row2>
*<SrNo>4</SrNo>
*<ITEM_CODE_FIELD>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</ITEM_CODE_FIELD>
*<sap_code>Mirum est</sap_code>
*<MOD_No>Licebit auctore</MOD_No>
*<Pack>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</Pack>
*<UNIT>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</UNIT>
*<Quantity>Experieris non Dianam magis montibus quam Minervam inerare.</Quantity>
*</Row2>
*<Row2>
*<SrNo>7</SrNo>
*<ITEM_CODE_FIELD>Mirum est ut animus agitatione motuque corporis excitetut.</ITEM_CODE_FIELD>
*<sap_code>Proinde</sap_code>
*<MOD_No>Am undique</MOD_No>
*<Pack>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</Pack>
*<UNIT>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</UNIT>
*<Quantity>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</Quantity>
*</Row2>
*<Row2>
*<SrNo>10</SrNo>
*<ITEM_CODE_FIELD>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</ITEM_CODE_FIELD>
*<sap_code>Ad retia sedebam</sap_code>
*<MOD_No>Vale</MOD_No>
*<Pack>Experieris non Dianam magis montibus quam Minervam inerare.</Pack>
*<UNIT>Mirum est ut animus agitatione motuque corporis excitetut.</UNIT>
*<Quantity>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</Quantity>
*</Row2>
*</Table3>
*<Table3>
*<Row2>
*<SrNo>3</SrNo>
*<ITEM_CODE_FIELD>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</ITEM_CODE_FIELD>
*<sap_code>Ego ille</sap_code>
*<MOD_No>Si manu vacuas</MOD_No>
*<Pack>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</Pack>
*<UNIT>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</UNIT>
*<Quantity>Experieris non Dianam magis montibus quam Minervam inerare.</Quantity>
*</Row2>
*<Row2>
*<SrNo>6</SrNo>
*<ITEM_CODE_FIELD>Mirum est ut animus agitatione motuque corporis excitetut.</ITEM_CODE_FIELD>
*<sap_code>Apros tres et quidem</sap_code>
*<MOD_No>Mirum est</MOD_No>
*<Pack>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</Pack>
*<UNIT>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</UNIT>
*<Quantity>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</Quantity>
*</Row2>
*<Row2>
*<SrNo>9</SrNo>
*<ITEM_CODE_FIELD>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</ITEM_CODE_FIELD>
*<sap_code>Licebit auctore</sap_code>
*<MOD_No>Proinde</MOD_No>
*<Pack>Experieris non Dianam magis montibus quam Minervam inerare.</Pack>
*<UNIT>Mirum est ut animus agitatione motuque corporis excitetut.</UNIT>
*<Quantity>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</Quantity>
*</Row2>
*</Table3>
*<Table3>
*<Row2>
*<SrNo>12</SrNo>
*<ITEM_CODE_FIELD>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</ITEM_CODE_FIELD>
*<sap_code>Am undique</sap_code>
*<MOD_No>Ad retia sedebam</MOD_No>
*<Pack>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</Pack>
*<UNIT>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</UNIT>
*<Quantity>Experieris non Dianam magis montibus quam Minervam inerare.</Quantity>
*</Row2>
*<Row2>
*<SrNo>2</SrNo>
*<ITEM_CODE_FIELD>Mirum est ut animus agitatione motuque corporis excitetut.</ITEM_CODE_FIELD>
*<sap_code>Vale</sap_code>
*<MOD_No>Ego ille</MOD_No>
*<Pack>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</Pack>
*<UNIT>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</UNIT>
*<Quantity>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</Quantity>
*</Row2>
*<Row2>
*<SrNo>5</SrNo>
*<ITEM_CODE_FIELD>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</ITEM_CODE_FIELD>
*<sap_code>Si manu vacuas</sap_code>
*<MOD_No>Apros tres et quidem</MOD_No>
*<Pack>Experieris non Dianam magis montibus quam Minervam inerare.</Pack>
*<UNIT>Mirum est ut animus agitatione motuque corporis excitetut.</UNIT>
*<Quantity>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</Quantity>
*</Row2>
*</Table3>
*<gst_in_words/>
*<gst_taxes>
*<transaction_value>5.40</transaction_value>
*<transportcost>6.61</transportcost>
*<IGST>Mirum est</IGST>
*<igst_per>Licebit auctore</igst_per>
*<igst_toal>Proinde</igst_toal>
*<CGST>Am undique</CGST>
*<cgst_per>Ad retia sedebam</cgst_per>
*<cgst_toal>Vale</cgst_toal>
*<SGST>Ego ille</SGST>
*<sgst_per>Si manu vacuas</sgst_per>
*<sgst_toal>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</sgst_toal>
*<TCS>Apros tres et quidem</TCS>
*<tcs_per>Mirum est</tcs_per>
*<tcs_toal>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</tcs_toal>
*<Grand_Total>Licebit auctore</Grand_Total>
*<grand_toal>Proinde</grand_toal>
*</gst_taxes>
*</bdyMain>


*<bdyMain>
*<CompanyCode>Am undique</CompanyCode>
*<plant>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</plant>
*<Invoice_No>Ad retia sedebam</Invoice_No>
*<LR_NO>Vale</LR_NO>
*<Invoice_Date>20040606T101010</Invoice_Date>
*<Transporter_Name>Ego ille</Transporter_Name>
*<Eway_Bill_No>Si manu vacuas</Eway_Bill_No>
*<YY1_VehicleNo1_BDH>Apros tres et quidem</YY1_VehicleNo1_BDH>
*<YY1_ENTRYTIME_BDH>Mirum est</YY1_ENTRYTIME_BDH>
*<INR_No>Experieris non Dianam magis montibus quam Minervam inerare.</INR_No>
*<Bill_Doc_No/>
*<Eway_No/>
*<frm_all_billto>
*<Comp_Name>Licebit auctore</Comp_Name>
*<Addline_1>Proinde</Addline_1>
*<Addline_2>Am undique</Addline_2>
*<Addline_3>Ad retia sedebam</Addline_3>
*<Addline_4>Vale</Addline_4>
*<Addline_5>Ego ille</Addline_5>
*<State>Si manu vacuas</State>
*<State_Code>Apros tres et quidem</State_Code>
*<GSTIN_No>Mirum est</GSTIN_No>
*<Pan_No>Licebit auctore</Pan_No>
*</frm_all_billto>
*<frm_all_ship_to>
*<Ship_to_add>Proinde</Ship_to_add>
*<Ship_to_add1>Am undique</Ship_to_add1>
*<Ship_to_add2>Ad retia sedebam</Ship_to_add2>
*<Ship_to_add3>Vale</Ship_to_add3>
*<Ship_to_add4>Ego ille</Ship_to_add4>
*<State>Si manu vacuas</State>
*<State_Code>Apros tres et quidem</State_Code>
*<GSTIN_No>Mirum est</GSTIN_No>
*</frm_all_ship_to>
*<frm_BArcode>
*<Export_Under>Licebit auctore</Export_Under>
*<Unloading_Point>Proinde</Unloading_Point>
*<ImageField1/>
*</frm_BArcode>
*<YY1_PODATE_BDH>20040606T101010</YY1_PODATE_BDH>
*<YY1_EDINO_BDH>Mirum est ut animus agitatione motuque corporis excitetut.</YY1_EDINO_BDH>
*<VENDOR_CODE_FIELD>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</VENDOR_CODE_FIELD>
*<INVOICE_N_FILED>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</INVOICE_N_FILED>
*<INVOICE_DATE_FIELD>06-06-2004</INVOICE_DATE_FIELD>
*<PO_NO_FIELD>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</PO_NO_FIELD>
*<LINE_ITEM_FIELD>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</LINE_ITEM_FIELD>
*<HSN_CODE_FIELD>Experieris non Dianam magis montibus quam Minervam inerare.</HSN_CODE_FIELD>
*<INVOICE_QTY_FIELD>7.0</INVOICE_QTY_FIELD>
*<BILL_AMOUNT_FIELD>7.7</BILL_AMOUNT_FIELD>
*<Rate_Amortization>Mirum est ut animus agitatione motuque corporis excitetut.</Rate_Amortization>
*<PO_Item/>
*<customer_material/>
*<Tot_net_amount/>
*<EDI_No/>
*<Puchorf_by_Cust/>
*<Table3>
*<Row2>
*<SrNo>8</SrNo>
*<ITEM_CODE_FIELD>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</ITEM_CODE_FIELD>
*<sap_code>Am undique</sap_code>
*<MOD_No>Ad retia sedebam</MOD_No>
*<Pack>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</Pack>
*<UNIT>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</UNIT>
*<Quantity>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</Quantity>
*</Row2>
*<Row2>
*<SrNo>11</SrNo>
*<ITEM_CODE_FIELD>Experieris non Dianam magis montibus quam Minervam inerare.</ITEM_CODE_FIELD>
*<sap_code>Vale</sap_code>
*<MOD_No>Ego ille</MOD_No>
*<Pack>Mirum est ut animus agitatione motuque corporis excitetut.</Pack>
*<UNIT>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</UNIT>
*<Quantity>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</Quantity>
*</Row2>
*<Row2>
*<SrNo>1</SrNo>
*<ITEM_CODE_FIELD>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</ITEM_CODE_FIELD>
*<sap_code>Si manu vacuas</sap_code>
*<MOD_No>Apros tres et quidem</MOD_No>
*<Pack>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</Pack>
*<UNIT>Experieris non Dianam magis montibus quam Minervam inerare.</UNIT>
*<Quantity>Mirum est ut animus agitatione motuque corporis excitetut.</Quantity>
*</Row2>
*</Table3>
*<Table3>
*<Row2>
*<SrNo>4</SrNo>
*<ITEM_CODE_FIELD>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</ITEM_CODE_FIELD>
*<sap_code>Mirum est</sap_code>
*<MOD_No>Licebit auctore</MOD_No>
*<Pack>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</Pack>
*<UNIT>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</UNIT>
*<Quantity>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</Quantity>
*</Row2>
*<Row2>
*<SrNo>7</SrNo>
*<ITEM_CODE_FIELD>Experieris non Dianam magis montibus quam Minervam inerare.</ITEM_CODE_FIELD>
*<sap_code>Proinde</sap_code>
*<MOD_No>Am undique</MOD_No>
*<Pack>Mirum est ut animus agitatione motuque corporis excitetut.</Pack>
*<UNIT>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</UNIT>
*<Quantity>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</Quantity>
*</Row2>
*<Row2>
*<SrNo>10</SrNo>
*<ITEM_CODE_FIELD>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</ITEM_CODE_FIELD>
*<sap_code>Ad retia sedebam</sap_code>
*<MOD_No>Vale</MOD_No>
*<Pack>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</Pack>
*<UNIT>Experieris non Dianam magis montibus quam Minervam inerare.</UNIT>
*<Quantity>Mirum est ut animus agitatione motuque corporis excitetut.</Quantity>
*</Row2>
*</Table3>
*<Table3>
*<Row2>
*<SrNo>3</SrNo>
*<ITEM_CODE_FIELD>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</ITEM_CODE_FIELD>
*<sap_code>Ego ille</sap_code>
*<MOD_No>Si manu vacuas</MOD_No>
*<Pack>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</Pack>
*<UNIT>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</UNIT>
*<Quantity>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</Quantity>
*</Row2>
*<Row2>
*<SrNo>6</SrNo>
*<ITEM_CODE_FIELD>Experieris non Dianam magis montibus quam Minervam inerare.</ITEM_CODE_FIELD>
*<sap_code>Apros tres et quidem</sap_code>
*<MOD_No>Mirum est</MOD_No>
*<Pack>Mirum est ut animus agitatione motuque corporis excitetut.</Pack>
*<UNIT>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</UNIT>
*<Quantity>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</Quantity>
*</Row2>
*<Row2>
*<SrNo>9</SrNo>
*<ITEM_CODE_FIELD>Iam undique silvae et solitudo ipsumque illud silentium quod venationi datur magna cogitationis incitamenta sunt.</ITEM_CODE_FIELD>
*<sap_code>Licebit auctore</sap_code>
*<MOD_No>Proinde</MOD_No>
*<Pack>Proinde cum venabere, licebit, auctore me, ut panarium et lagunculam sic etiam pugillares feras.</Pack>
*<UNIT>Experieris non Dianam magis montibus quam Minervam inerare.</UNIT>
*<Quantity>Mirum est ut animus agitatione motuque corporis excitetut.</Quantity>
*</Row2>
*</Table3>
*<gst_in_words/>
*<gst_taxes>
*<transaction_value>7.82</transaction_value>
*<transportcost>9.03</transportcost>
*<IGST>Am undique</IGST>
*<igst_per>Ad retia sedebam</igst_per>
*<igst_toal>Vale</igst_toal>
*<CGST>Ego ille</CGST>
*<cgst_per>Si manu vacuas</cgst_per>
*<cgst_toal>Apros tres et quidem</cgst_toal>
*<SGST>Mirum est</SGST>
*<sgst_per>Licebit auctore</sgst_per>
*<sgst_toal>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</sgst_toal>
*<TCS>Proinde</TCS>
*<tcs_per>Am undique</tcs_per>
*<tcs_toal>meditabar aliquid enotabamque, ut, si manus vacuas, plenas tamen ceras reportarem.</tcs_toal>
*<Grand_Total>Ad retia sedebam</Grand_Total>
*<grand_toal>Vale</grand_toal>
*</gst_taxes>
*</bdyMain>


 ENDMETHOD.
ENDCLASS.
