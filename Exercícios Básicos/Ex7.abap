*&---------------------------------------------------------------------*
*& Report  ZPR_BM_TESTE
*&---------------------------------------------------------------------*
*& Exercício 7: Trabalhando com Data e Hora
*&---------------------------------------------------------------------*
REPORT zpr_bm_teste.

DATA: lv_today      TYPE sy-datum,
      lv_date_formatted TYPE string.

lv_today = SY-DATUM.

CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
  EXPORTING
    date_internal = lv_today
  IMPORTING
    date_external = lv_date_formatted.

WRITE: / 'A data de hoje é:', lv_date_formatted.