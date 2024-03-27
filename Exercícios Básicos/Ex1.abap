*&---------------------------------------------------------------------*
*& Report ZPR_BM_TESTE
*&---------------------------------------------------------------------*
*& Exercício 1: Declaração de Dados e Exibição
*&---------------------------------------------------------------------*
REPORT ZPR_BM_TESTE.

DATA: v_nome TYPE string VALUE 'Hideki',
      v_idade TYPE i VALUE 19,
      v_salario TYPE p DECIMALS 2 VALUE 1000.

START-OF-SELECTION.
  WRITE: / 'Nome:', v_nome,
         / 'Idade:', v_idade,
         / 'Salário:', v_salario.