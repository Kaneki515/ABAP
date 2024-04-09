*&---------------------------------------------------------------------*
*& Report ZPR_BM_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpr_bm_alv.

TABLES: sflight.

DATA: sflights TYPE TABLE OF sflight,
      cl_table TYPE REF TO cl_salv_table.

START-OF-SELECTION.
  PERFORM get_dados.
  PERFORM display_alv.

FORM get_dados.
  SELECT *
    FROM  sflight
    INTO TABLE sflights.

  LOOP AT sflights INTO sflight.
    WRITE sflight-carrid.
  ENDLOOP.
ENDFORM.

FORM display_alv.

  CALL METHOD cl_salv_table=>factory
    IMPORTING
      r_salv_table = cl_table
    CHANGING
      t_table      = sflights.

  PERFORM feed_functions.

  CALL METHOD cl_table->display( ).
ENDFORM.

FORM feed_functions.
  DATA lc_functions TYPE REF TO cl_salv_functions.

  lc_functions = cl_table->get_functions( ).
  lc_functions->set_all( abap_true ).
ENDFORM.