*&---------------------------------------------------------------------*
*& Report ZPR_BM_TESTE
*&---------------------------------------------------------------------*
*& Exercício 4: Manipulação de Strings
*&---------------------------------------------------------------------*
REPORT zpr_bm_teste.

DATA: v_nome          TYPE string VALUE 'João',
      v_sobrenome     TYPE string VALUE 'Silva',
      v_nome_completo TYPE string.

*&---------------------------------------------------------------------*
*& Concatenando sem utilizar CONCATENATE
*&---------------------------------------------------------------------*

v_nome_completo = v_nome && ' ' && v_sobrenome.

WRITE: / 'Nome completo:', v_nome_completo.

DATA:
  palavra1     TYPE string,
  palavra2     TYPE string,
  palavra3     TYPE string,
  concatenacao TYPE string.

palavra1 = 'Hello'.
palavra2 = 'World'.
palavra3 = '!'.

CONCATENATE palavra1
            palavra2
            palavra3
INTO concatenacao.

WRITE / concatenacao.

*&---------------------------------------------------------------------*
*& Concatenando com separação space entre as palavras palavras
*&---------------------------------------------------------------------*

CONCATENATE palavra1
            palavra2
            palavra3
INTO concatenacao SEPARATED BY space.

WRITE / concatenacao.