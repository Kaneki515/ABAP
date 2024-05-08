*&---------------------------------------------------------------------*
*&  REPORT ZPR_BM_DEMLEO
*&---------------------------------------------------------------------*
*& Nome: ZPR_BM_DEMLEO
*& Tipo: Report
*& Objetivo: Gerar relatório
*& Data/Hora: Quarta, Mario 05, 2024 (GMT-3) - 15:00
*& Desenvolvedor: Bruno Misufara (Infinitfy)
*&---------------------------------------------------------------------*
*& Versão 1: Bruno Misufara - Inicio Desenvolvimento - NPLK900120
*& Versão 2: ?
*& Versão 3: ?
*&---------------------------------------------------------------------*
REPORT zpr_bm_demleo.

***************
***	TABELAS	***
***************
TABLES:
  mat_handling,
  material,
  storehouse,
  branch.

***************
***	 TYPES  ***
***************
TYPES: BEGIN OF ty_it,
         movnr       TYPE mat_handling-movnr,
         branr       TYPE branch-branr,
         compnr      TYPE branch-compnr,
         whnr        TYPE storehouse-whnr,
         description TYPE storehouse-description,
         matnr       TYPE material-matnr,
         maktx       TYPE material-maktx,
         quantity    TYPE mat_handling-quantity,
         price       TYPE material-price,
         valor       TYPE material-price,
         doctype     TYPE mat_handling-doctype,
         docnr       TYPE mat_handling-docnr,
         movtyp      TYPE mat_handling-movtyp,
         erdat       TYPE mat_handling-erdat,
         entrytime   TYPE mat_handling-entrytime,
         ernam       TYPE mat_handling-ernam,
       END OF ty_it.

*************************
***	 INTERNAL TABLES  ***
*************************
DATA: it_it TYPE TABLE OF ty_it.

*******************
*** WORK AREAS  ***
*******************
DATA: wa_it TYPE ty_it.


***************************************
***         SELECT-OPTIONS          ***
***************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
SELECT-OPTIONS: s_movnr FOR mat_handling-movnr,
                s_whnr  FOR storehouse-whnr,
                s_matnr FOR mat_handling-matnr.
SELECTION-SCREEN END OF BLOCK b1.

* START-OF-SELECTION
START-OF-SELECTION.
  PERFORM zf_select_data.

* END-OF-SELECTION
END-OF-SELECTION.

*--------------------------------------------------------*
*                 Form  Z_SELECT_DATA                    *
*--------------------------------------------------------*
*   SELECIONA OS DADOS A SEREM EXIBIDOS PELO RELATÓRIO   *
*--------------------------------------------------------*
FORM zf_select_data.
  SELECT
    movnr,
    quantity,
    doctype,
    docnr,
    movtyp,
    erdat,
    entrytime,
    ernam,
    whnr,
    matnr
    INTO TABLE @DATA(lt_mat_handling)
    FROM mat_handling
    WHERE movnr IN @s_movnr AND matnr IN @s_matnr.

  LOOP AT lt_mat_handling ASSIGNING FIELD-SYMBOL(<fs_mat_handling>).

    SELECT DISTINCT
      whnr,
      description
      INTO TABLE @DATA(lt_storehouse)
      FROM storehouse
      WHERE whnr = @<fs_mat_handling>-whnr AND whnr IN @s_whnr.

    SELECT DISTINCT
      branr,
      compnr
      INTO TABLE @DATA(lt_branch)
      FROM branch
      WHERE branr = @<fs_mat_handling>-whnr.

    SELECT DISTINCT
      matnr,
      maktx,
      price
      INTO TABLE @DATA(lt_material)
      FROM material
      WHERE matnr = @<fs_mat_handling>-matnr.

    READ TABLE lt_storehouse INTO DATA(lw_storehouse) WITH KEY whnr = <fs_mat_handling>-whnr.
    READ TABLE lt_branch INTO DATA(lw_branch) WITH KEY branr = <fs_mat_handling>-whnr.
    READ TABLE lt_material INTO DATA(lw_material) WITH KEY matnr = <fs_mat_handling>-matnr.

    wa_it-movnr = <fs_mat_handling>-movnr.
    wa_it-branr = lw_branch-branr.
    wa_it-compnr = lw_branch-compnr.
    wa_it-whnr = lw_storehouse-whnr.
    wa_it-description = lw_storehouse-description.
    wa_it-matnr = lw_material-matnr.
    wa_it-maktx = lw_material-maktx.
    wa_it-quantity = <fs_mat_handling>-quantity.
    wa_it-price = lw_material-price.
    wa_it-valor = <fs_mat_handling>-quantity * lw_material-price.
    wa_it-doctype = <fs_mat_handling>-doctype.
    wa_it-docnr = <fs_mat_handling>-docnr.
    wa_it-movtyp = <fs_mat_handling>-movtyp.
    wa_it-erdat = <fs_mat_handling>-erdat.
    wa_it-entrytime = <fs_mat_handling>-entrytime.
    wa_it-ernam = <fs_mat_handling>-ernam.

    APPEND wa_it TO it_it.
  ENDLOOP.

  PERFORM zf_display_alv.

ENDFORM.


*--------------------------------------------------------*
*                 Form  ZF_DISPLAY_ALV                   *
*--------------------------------------------------------*
*     Exibe o relátorio ALV com os dados selecionados    *
*--------------------------------------------------------*
FORM zf_display_alv.
  DATA: lt_fieldcat TYPE lvc_t_fcat.
  DATA: lw_layout   TYPE lvc_s_layo.
  DATA: lw_saida TYPE ty_it.

  lw_layout-zebra = abap_true.
  lw_layout-cwidth_opt = abap_true.

* criação da tabela de fieldcat
  CALL FUNCTION 'STRALAN_FIELDCAT_CREATE'
    EXPORTING
      is_structure = lw_saida
    IMPORTING
      et_fieldcat  = lt_fieldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program = sy-repid
      is_layout_lvc      = lw_layout
      it_fieldcat_lvc    = lt_fieldcat
    TABLES
      t_outtab           = it_it
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc NE 0.
    MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1) WITH TEXT-e02.
  ENDIF.
ENDFORM.