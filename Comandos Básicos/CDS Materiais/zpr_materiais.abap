*&---------------------------------------------------------------------*
*& Report ZPR_MATERIAIS.
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpr_materiais.

***************
***	TABELAS	***
***************
TABLES: mat_stock.

*************************
***	 INTERNAL TABLES  ***
*************************
DATA it_estoque TYPE TABLE OF zcds_bm_estoque.

***************************************
*** PARAMETROS DE SELEÇÃO DE DADOS  ***
***************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
SELECT-OPTIONS s_whnr FOR mat_stock-whnr.
SELECTION-SCREEN END OF BLOCK b1.

* START-OF-SELECTION
START-OF-SELECTION.
  PERFORM zf_select_data_stock.

* END-OF-SELECTION
END-OF-SELECTION.

FORM sub_pf_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZEXECUTE'.
ENDFORM.

FORM user_command USING r_ucomm LIKE sy-ucomm rs_selfield TYPE slis_selfield.
  IF r_ucomm EQ '&FUN'.
    MESSAGE 'Func' TYPE 'S'.
    PERFORM zf_select_data_material.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_select_data_stock
*&---------------------------------------------------------------------*
*& Seleciona os dados da CDS View a serem exibidos
*&---------------------------------------------------------------------*

FORM zf_select_data_stock.

  SELECT * FROM zcds_bm_estoque
    INTO TABLE @it_estoque
    WHERE whnr IN @s_whnr.

  PERFORM zf_display_alv_stock.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form ZF_DISPLAY_ALV_STOCK
*&---------------------------------------------------------------------*
*& Exibe os dados selecionas no form zf_select_data_stock
*&---------------------------------------------------------------------*

FORM zf_display_alv_stock.
  DATA: wa_fieldcat TYPE slis_fieldcat_alv. "Passará a formatação das colunas
  DATA: wa_layout   TYPE slis_layout_alv. "Pode passar configurações de layout da tabela
  DATA: it_fieldcat TYPE slis_t_fieldcat_alv. "Guardará a formatação das colunas

  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname = 'mark'.
  wa_fieldcat-edit = abap_on.
  wa_fieldcat-no_out = abap_true.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'whnr'.
  wa_fieldcat-seltext_l = 'Código Armazém'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'description'.
  wa_fieldcat-seltext_l = 'Armazém'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'regio'.
  wa_fieldcat-seltext_l = 'Região'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'quantity'.
  wa_fieldcat-seltext_l = 'Total em Estoque'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_layout-colwidth_optimize = abap_true. "Layout para ajustar o tamanho da

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'SUB_PF_STATUS'
      i_callback_user_command  = 'USER_COMMAND'
      i_grid_title             = 'Armazens e Estoque'
      is_layout                = wa_layout "passando o layout
      it_fieldcat              = it_fieldcat "passando a estrutura
    TABLES
      t_outtab                 = it_estoque. "passando os dados para exibição
  IF sy-subrc <> 0.

  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form ZF_SELECT_DATA_MATERIAL
*&---------------------------------------------------------------------*
*& Seleciona os dados a serem exibidos pelo a ALV podendendo ser de
*& todos os armazem ou somente do selecionado na tela de Armazém.
*&---------------------------------------------------------------------*
FORM zf_select_data_material.

  DATA: e_grid TYPE REF TO cl_gui_alv_grid.
  DATA: t_selected_rows TYPE lvc_t_row.
  DATA: lr_whnr TYPE RANGE OF mat_handling-whnr.
  DATA: lw_whnr LIKE LINE OF lr_whnr.
  DATA: lv_indice(10) TYPE n.

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = e_grid.

  CALL METHOD e_grid->check_changed_data.
  CALL METHOD e_grid->get_selected_rows
    IMPORTING
      et_index_rows = t_selected_rows.

  LOOP AT t_selected_rows ASSIGNING FIELD-SYMBOL(<ls_selected>).
    lv_indice = <ls_selected>-index.
    READ TABLE it_estoque INDEX lv_indice ASSIGNING FIELD-SYMBOL(<ls_estoque>).
    lw_whnr-sign = 'I'.
    lw_whnr-option = 'EQ'.
    lw_whnr-low = <ls_estoque>-whnr.
    COLLECT lw_whnr INTO lr_whnr.
  ENDLOOP.

  SELECT *
    FROM zcds_bm_materiais
    INTO TABLE @DATA(lt_materiais)
    WHERE whnr IN @lr_whnr.



  PERFORM zf_display_alv_material TABLES lt_materiais.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form ZF_DISPLAY_ALV_MATERIAL
*&---------------------------------------------------------------------*
*& Exibe um alv no qual mosta os dados.
*&---------------------------------------------------------------------*
FORM zf_display_alv_material TABLES lt_materiais.
  DATA: wa_fieldcat TYPE slis_fieldcat_alv. "Passará a formatação das colunas
  DATA: wa_layout   TYPE slis_layout_alv. "Pode passar configurações de layout da tabela
  DATA: it_fieldcat TYPE slis_t_fieldcat_alv. "Guardará a formatação das colunas

  wa_fieldcat-fieldname = 'movnr'.
  wa_fieldcat-seltext_l = 'Número Movimento'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'whnr'.
  wa_fieldcat-seltext_l = 'Código de Armazém'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'branr'.
  wa_fieldcat-seltext_l = 'Filial'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'description'.
  wa_fieldcat-seltext_l = 'Descrição Armazém'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'doctype'.
  wa_fieldcat-seltext_l = 'Tipo do Documento'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'movtyp'.
  wa_fieldcat-seltext_l = 'Tipo de Movimentação'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'matnr'.
  wa_fieldcat-seltext_l = 'Material'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'maktx'.
  wa_fieldcat-seltext_l = 'Descrição do Material'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'quantity'.
  wa_fieldcat-seltext_l = 'Quantidade'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'price'.
  wa_fieldcat-seltext_l = 'Preço Material'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'valor'.
  wa_fieldcat-seltext_l = 'Total Movimentado'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'erdat'.
  wa_fieldcat-seltext_l = 'Data Criação Registro'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'entrytime'.
  wa_fieldcat-seltext_l = 'Data de Entrada'.
  wa_fieldcat-emphasize = 'C100'.
  wa_fieldcat-just = 'C'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_layout-colwidth_optimize = abap_true. "Layout para ajustar o tamanho da

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
*     i_callback_pf_status_set = 'sub_pf_status'
      i_callback_user_command = 'USER_COMMAND'
      i_grid_title            = 'Produtos'
      is_layout               = wa_layout "passando o layout
      it_fieldcat             = it_fieldcat "passando a estrutura
    TABLES
      t_outtab                = lt_materiais. "passando os dados para exibição
  IF sy-subrc <> 0.
  ENDIF.
ENDFORM.