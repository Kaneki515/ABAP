*&---------------------------------------------------------------------*
*& Report ZPR_BM_TESTE
*&---------------------------------------------------------------------*
*& Exercício 3: Estruturas Condicionais
*&---------------------------------------------------------------------*
REPORT zpr_bm_teste.

"IF, ELSEIF e ELSE

DATA v_num TYPE i.

v_num = -1.

IF v_num > 0.
  WRITE: / 'O número é positivo'.
ELSEIF v_num < 0.
  WRITE : / 'O número é negativo'.
ELSE.
  WRITE: / 'O número é zero'.
ENDIF.
