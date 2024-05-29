******************
*** VARIÁVEIS  ***
******************
DATA gv_variant TYPE disvariant.

*&---------------------------------------------------------------------*
*&  SELECTION-SCREEN para o Parâmetro para escolher o tipo de layout do ALV
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS: p_vari TYPE disvariant-variant.
SELECTION-SCREEN END OF BLOCK b2.

AT SELECTION-SCREEN ON p_vari.
  PERFORM alv_variant_existence CHANGING gv_variant.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vari.
  PERFORM alv_variant_f4 CHANGING gv_variant.


*&---------------------------------------------------------------------*
*&  FORMS ALV_VARIANT_EXISTENCE E ALV_VARIANT_F4
*&---------------------------------------------------------------------*
*& Utilizado para salvar o layout do ALV
*&---------------------------------------------------------------------*
FORM alv_variant_existence CHANGING os_variant TYPE disvariant. "#EC CI_FORM
  CHECK p_vari IS NOT INITIAL.

  os_variant-report  = sy-repid.
  os_variant-variant = p_vari.

  IF p_vari CP '/*'.
    os_variant-username = sy-uname.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_VARIANT_EXISTENCE'
    EXPORTING
      i_save        = sy-abcde(1)
    CHANGING
      cs_variant    = os_variant
    EXCEPTIONS
      wrong_input   = 1
      not_found     = 2
      program_error = 3
      OTHERS        = 4.

  IF sy-subrc <> 0.
    MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1)
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.

FORM alv_variant_f4  CHANGING os_variant TYPE disvariant.  "#EC CI_FORM
  DATA: lv_exit(1) TYPE c.

  os_variant-report = sy-repid.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = os_variant
      i_save     = sy-abcde(1)
    IMPORTING
      e_exit     = lv_exit
      es_variant = os_variant
    EXCEPTIONS
      not_found  = 2.

  IF sy-subrc EQ 2.
    MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1)
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSEIF lv_exit = space.
    p_vari = os_variant-variant.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& ENDFORMS ALV_VARIANT_EXISTENCE E ALV_VARIANT_F4
*&---------------------------------------------------------------------*