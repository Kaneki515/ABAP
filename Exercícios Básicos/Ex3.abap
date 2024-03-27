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

" Case

DATA: lv_day TYPE i VALUE 5.

CASE lv_day.
  WHEN 1.
    WRITE: / 'Domingo'.
  WHEN 2.
    WRITE: / 'Segunda-feira'.
  WHEN 3.
    WRITE: / 'Terça-feira'.
  WHEN 4.
    WRITE: / 'Quarta-feira'.
  WHEN 5.
    WRITE: / 'Quinta-feira'.
  WHEN 6.
    WRITE: / 'Sexta-feira'.
  WHEN 7.
    WRITE: / 'Sábado'.
  WHEN OTHERS.
    WRITE: / 'Dia inválido'.
ENDCASE.