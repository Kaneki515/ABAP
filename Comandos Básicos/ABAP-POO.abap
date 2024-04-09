*&---------------------------------------------------------------------*
*& Report ZPR_BM_TESTE3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpr_bm_teste3.

CLASS animal DEFINITION.
  PUBLIC SECTION.

    DATA: cor_pele TYPE string.

    METHODS: comer.

ENDCLASS.

CLASS animal IMPLEMENTATION.

  METHOD comer.
    WRITE: 'Animal está comendo', /.
  ENDMETHOD.
ENDCLASS.


CLASS ave DEFINITION INHERITING FROM animal.

  PUBLIC SECTION.

    METHODS voar.

ENDCLASS.

CLASS ave IMPLEMENTATION.

  METHOD voar.
    WRITE: 'Ave está voando', /.
  ENDMETHOD.

ENDCLASS.

DATA: cl_animal_1 TYPE REF TO animal,
      cl_animal_2 TYPE REF TO animal,
      cl_ave_1    TYPE REF TO ave.

INITIALIZATION.
  CREATE OBJECT cl_animal_1.
  CREATE OBJECT cl_animal_2.
  CREATE OBJECT cl_ave_1.

  cl_animal_1->cor_pele = 'Branco'.
  WRITE: cl_animal_1->cor_pele, /.

  cl_animal_2->cor_pele = 'Roxo'.
  WRITE: cl_animal_2->cor_pele, /.
  cl_animal_2->comer( ).

  cl_ave_1->cor_pele = 'Preta'.
  WRITE: cl_ave_1->cor_pele, /.
  cl_ave_1->voar( ).
  cl_ave_1->comer( ).