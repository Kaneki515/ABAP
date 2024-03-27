*&---------------------------------------------------------------------*
*& Report  ZPR_BM_TESTE
*&---------------------------------------------------------------------*
*& # Exercício 10: Programa que informa o tipo de veiculo que você pode dirigir pela categoria
*&---------------------------------------------------------------------*
REPORT zpr_bm_teste.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS: p_cat(1) TYPE c.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  CASE p_cat.
    WHEN 'A' or 'a'.
      WRITE: 'Moto'.
    WHEN 'B' or 'b'.
      WRITE: 'Carro'.
    WHEN 'C' or 'c'.
      WRITE: 'Veículo de carga'.
    WHEN 'D' or 'd'.
      WRITE: 'Transporte de passageiros'.
    WHEN 'E' or 'e'.
      WRITE: 'Caminhões'.
  ENDCASE.