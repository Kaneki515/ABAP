*&---------------------------------------------------------------------*
*& Report ZPR_BM_TESTE3
*&---------------------------------------------------------------------*
*&  Programas sobre botões ABAP
*&---------------------------------------------------------------------*
REPORT zpr_bm_teste3.

TABLES: ztb_bm_teste, sscrfields.

TYPES: BEGIN OF ty_funcionario, "Define e estrutura da tabela interna.
         id   TYPE ztb_bm_teste-id,
         nome TYPE ztb_bm_teste-nome,
       END OF ty_funcionario.

DATA: it_funcionarios TYPE TABLE OF ty_funcionario,
      wa_funcionario  TYPE ty_funcionario,
      lv_id           TYPE string,
      list            TYPE vrm_values.

SELECTION-SCREEN PUSHBUTTON 1(30)  but1 USER-COMMAND cli1. "Comando para PushButton

PARAMETERS: p_chkbox AS CHECKBOX DEFAULT 'X' USER-COMMAND chk, "Comando para colocar CheckBox.
            p_radio  RADIOBUTTON GROUP rb USER-COMMAND rbu, "Comando para Radio Button.
            p_radio2 RADIOBUTTON GROUP rb, "Comando para Radio Button.
            p_drp    AS LISTBOX VISIBLE LENGTH 30 MODIF ID pdf. "Comando para List Box|DropDown.

INITIALIZATION.
  but1 = 'PushButton'. "Define o Texto no PushButton.

AT SELECTION-SCREEN OUTPUT.
  CLEAR: it_funcionarios, list. "Limpa os campos

  SELECT id FROM ztb_bm_teste INTO TABLE it_funcionarios. "Seleciona o id da tabela ztb_bm_teste e passa para a tabela interna.

  LOOP AT it_funcionarios INTO wa_funcionario.
    CLEAR: lv_id.
    lv_id = wa_funcionario-id. " Ajuste conforme necessário para combinar chave e texto
    APPEND VALUE #( key = lv_id text = wa_funcionario-id ) TO list.
  ENDLOOP.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = 'P_DRP'
      values = list.

AT SELECTION-SCREEN.
  IF sy-ucomm = 'CHK'. "Verifica se o CHK está selecionado user command.
    IF p_chkbox = 'X'. "Verifica se o CheckBox está selecionado.
      MESSAGE 'Checkbox is checked' TYPE 'S'.
    ELSE.
      MESSAGE 'Checkbox is not checked' TYPE 'S'.
    ENDIF.
  ENDIF.

  IF sy-ucomm = 'RBU'. "Verifica se o RBU está selecionado user command.
    IF p_radio = abap_true.
      MESSAGE 'Radio is checked' TYPE 'S'.
    ELSEIF p_radio2 = abap_true.
      MESSAGE 'Radio2 is checked' TYPE 'S'.
    ENDIF.
  ENDIF.

  CASE sscrfields."Case o PushButton.
    WHEN 'CLI1'. "Verifica qual PushButton foi pressionado.
      MESSAGE 'PushButton Pressionado' TYPE 'S'.
  ENDCASE.