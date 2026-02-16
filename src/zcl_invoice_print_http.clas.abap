class ZCL_INVOICE_PRINT_HTTP definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_INVOICE_PRINT_HTTP IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

    DATA(req) = request->get_form_fields(  ).
    DATA(FORMINV) = VALUE #( req[ name = 'billingfrom' ]-value OPTIONAL ) .
    DATA(TOINV) = VALUE #( req[ name = 'billingto' ]-value OPTIONAL ) .

    DATA(BILDATE) = VALUE #( req[ name = 'iddate' ]-value OPTIONAL ) .

    data :  INV TYPE RANGE OF I_BillingDocument-BillingDocument ,
          w_formnoCD LIKE LINE OF INV .

IF TOINV IS NOT INITIAL AND TOINV <> ' '  AND TOINV <> ''.

w_formnoCD-option = 'BT'.
w_formnoCD-sign = 'I'.
w_formnoCD-low = FORMINV.
w_formnoCD-high = TOINV.
APPEND w_formnoCD TO INV.

ELSEIF FORMINV IS NOT INITIAL AND FORMINV <> ' '  AND FORMINV <> ''.

w_formnoCD-option = 'BT'.
w_formnoCD-sign = 'I'.
w_formnoCD-low = |{ FORMINV ALPHA = IN }|.
w_formnoCD-high = |{ FORMINV ALPHA = IN }|.

APPEND w_formnoCD TO INV.

ENDIF.

    data :  DATE TYPE RANGE OF I_BillingDocument-BillingDocumentDate ,
          w_DATE LIKE LINE OF DATE .

IF BILDATE IS NOT INITIAL AND BILDATE <> ' '  AND BILDATE <> ''.

w_DATE-option = 'BT'.
w_DATE-sign = 'I'.
w_DATE-low = BILDATE.
w_DATE-high = BILDATE.
APPEND w_DATE TO DATE.

ENDIF.


SELECT  * FROM I_BillingDocument WITH PRIVILEGED ACCESS as  a  WHERE a~BillingDocument IN @INV
AND a~BillingDocumentDate IN @DATE INTO TABLE @DATA(IT).

DATA(l_merger) = cl_rspo_pdf_merger=>create_instance( ).

LOOP AT IT INTO DATA(WA).

      TRY.
          DATA(pdf) = zcl_tax_invoice_print=>read_posts( INVOICE_FROM = WA-BillingDocument ).
        CATCH cx_static_check.
          "handle exception
      ENDTRY.

DATA  pdf_xstring TYPE xSTRING.
pdf_xstring = xco_cp=>string( pdf )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value.
l_merger->add_document( pdf_xstring ).

ENDLOOP.

 TRY .
    DATA(l_poczone_PDF) = l_merger->merge_documents( ).
      CATCH cx_rspo_pdf_merger INTO DATA(l_exception).
        " Add a useful error handling here
    ENDTRY.
        DATA(response_final) = xco_cp=>xstring( l_poczone_PDF
      )->as_string( xco_cp_binary=>text_encoding->base64
      )->value .

   response->set_text( response_final ) .



  endmethod.
ENDCLASS.
