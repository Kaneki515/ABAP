*&---------------------------------------------------------------------*
*& Report ZPR_BM_TESTE
*&---------------------------------------------------------------------*
*& Exercício 4: Manipulação de Strings
*&---------------------------------------------------------------------*
REPORT zpr_bm_teste.

DATA: BEGIN OF it_scarr OCCURS 0,
        carrid TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
      END OF it_scarr.

SELECT carrid carrname FROM scarr INTO TABLE it_scarr.

START-OF-SELECTION.
  LOOP AT it_scarr.
    WRITE: / 'Código:', it_scarr-carrid, 'Nome:', it_scarr-carrname.
  ENDLOOP.