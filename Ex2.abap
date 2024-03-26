*&---------------------------------------------------------------------*
*& Report ZPR_BM_TESTE
*&---------------------------------------------------------------------*
*& Exercício 2: Uso de Loop para Processar Tabela Interna
*&---------------------------------------------------------------------*
REPORT zpr_bm_teste.

TYPES: BEGIN OF ty_funcionario,
         id   TYPE i,
         nome TYPE string,
       END OF ty_funcionario.

DATA: it_funcionarios TYPE TABLE OF ty_funcionario,
      wa_funcionario  TYPE ty_funcionario.

wa_funcionario = VALUE #( id = 1 nome = 'Bruno' ).
APPEND wa_funcionario TO it_funcionarios.

wa_funcionario = VALUE #( id = 2 nome = 'Daniel' ).
APPEND wa_funcionario TO it_funcionarios.

START-OF-SELECTION.
  LOOP AT it_funcionarios INTO wa_funcionario.
    WRITE: / 'Funcionário:', wa_funcionario-nome, 'ID:', wa_funcionario-id.
  ENDLOOP.