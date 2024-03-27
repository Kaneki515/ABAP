*&---------------------------------------------------------------------*
*& Report  ZPR_BM_TESTE
*&---------------------------------------------------------------------*
*& Exercício 6: Usando IF e THEN para Tratar Múltiplas Condições
*&---------------------------------------------------------------------*
REPORT zpr_bm_teste.

DATA: v_nota_media TYPE i,
      v_classificacao TYPE string.

v_nota_media = 6.

IF v_nota_media >= 0 AND v_nota_media <= 4.
  v_classificacao = 'Insuficiente'.
ELSEIF v_nota_media >= 5 AND v_nota_media <= 6.
  v_classificacao = 'Suficiente'.
ELSEIF v_nota_media >= 6 AND v_nota_media <= 7.
  v_classificacao = 'Bom'.
ELSEIF v_nota_media >= 8 AND v_nota_media <= 8.
  v_classificacao = 'Muito Bom'.
ELSEIF v_nota_media >= 9 AND v_nota_media <= 10.
  v_classificacao = 'Excelente'.
ELSE.
  v_classificacao = 'Nota inválida'.
ENDIF.

WRITE: / 'Classificação:', v_classificacao.