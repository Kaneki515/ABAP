*&---------------------------------------------------------------------*
*& Report  ZPR_BM_TESTE
*&---------------------------------------------------------------------*
*& # 1. Cadastro Simples de Funcionários
*&---------------------------------------------------------------------*
REPORT zpr_bm_teste.

INITIALIZATION.
*Chama a tabela transparente.
  TABLES: ztb_bm_teste.

* Determina que a estrutura de intenal table é a estrutura da tabela transparente.
  DATA: it_funcionarios TYPE TABLE OF ztb_bm_teste,
        wa_funcionario  TYPE ztb_bm_teste.
  SELECT * FROM ztb_bm_teste INTO TABLE it_funcionarios.

*Cria os radio buttons. Definindo que perticipam do grupo gr1 e o p_create é o botão padrão.
  PARAMETERS: p_create RADIOBUTTON GROUP gr1 DEFAULT 'X' USER-COMMAND uc,
              p_read   RADIOBUTTON GROUP gr1,
              p_update RADIOBUTTON GROUP gr1,
              p_delete RADIOBUTTON GROUP gr1.

*Criação das telas para os campos.
  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_id   TYPE ztb_bm_teste-id MODIF ID gr2,
              p_nome TYPE ztb_bm_teste-nome MODIF ID gr2.
  SELECTION-SCREEN END OF BLOCK b1.

  SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-003.
  PARAMETERS: p_id_up  TYPE ztb_bm_teste-id MODIF ID gr3,
              p_nom_up TYPE ztb_bm_teste-nome MODIF ID gr3.
  SELECTION-SCREEN END OF BLOCK b2.

  SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-004.
  PARAMETERS: p_id_del TYPE ztb_bm_teste-id MODIF ID gr4.
  SELECTION-SCREEN END OF BLOCK b3.

*Chama o Form da seção do qual está selecionado.
START-OF-SELECTION.
  IF p_create = 'X'.
    PERFORM fm_create_user.
  ELSEIF p_read = 'X'.
    PERFORM fm_read_user.
  ELSEIF p_update = 'X'.
    PERFORM fm_update_user.
  ELSEIF p_delete = 'X'.
    PERFORM fm_delete_user.
  ENDIF.

*Mostra as telas dependendo de qual radio button está selecionado.
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF p_create = 'X'.
      IF screen-group1 = 'GR2'.
        screen-active = 1.
      ELSEIF screen-group1 = 'GR4' OR screen-group1 = 'GR3'.
        screen-active = 0.
      ENDIF.

    ELSEIF p_read = 'X'.
      IF screen-group1 = 'GR4' OR screen-group1 = 'GR3'  OR screen-group1 = 'GR2'.
        screen-active = 0.
      ENDIF.
      cl_demo_output=>display( it_funcionarios ).
      RETURN.

    ELSEIF p_update = 'X'.
      IF screen-group1 = 'GR3'.
        screen-active = 1.
      ELSEIF screen-group1 = 'GR4' OR screen-group1 = 'GR2'.
        screen-active = 0.
      ENDIF.

    ELSEIF p_delete = 'X'.
      IF screen-group1 = 'GR4'.
        screen-active = 1.
      ELSEIF screen-group1 = 'GR3' OR screen-group1 = 'GR2'.
        screen-active = 0.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

*Form para Create.
FORM fm_create_user.
  CLEAR ztb_bm_teste.
  ztb_bm_teste-id = p_id.
  ztb_bm_teste-nome = p_nome.

  INSERT INTO ztb_bm_teste VALUES ztb_bm_teste.
  IF sy-subrc <> 0.
    MESSAGE 'Erro ao inserir o registro' TYPE 'E'.
  ELSE.
    COMMIT WORK.
    MESSAGE 'Registro inserido com sucesso' TYPE 'S'.
  ENDIF.
ENDFORM.

*Form para Read.
FORM fm_read_user.
  SELECT * FROM ztb_bm_teste INTO TABLE it_funcionarios.
ENDFORM.

*Form para Update.
FORM fm_update_user.
  SELECT SINGLE * FROM ztb_bm_teste INTO wa_funcionario WHERE id = p_id_up.

  IF sy-subrc = 0.
    DATA: lv_nome TYPE ztb_bm_teste-nome.

    lv_nome = p_nom_up.

    UPDATE ztb_bm_teste SET nome = lv_nome WHERE id = p_id_up.

    IF sy-subrc = 0.
      COMMIT WORK.
      MESSAGE 'Registro atualizado com sucesso.' TYPE 'S'.
    ELSE.
      MESSAGE 'Erro ao atualizar o registro.' TYPE 'E'.
    ENDIF.
  ELSE.
    MESSAGE 'Nenhum registro encontrado' TYPE 'E'.
  ENDIF.

ENDFORM.

* Fomr para Delete.
FORM fm_delete_user.
  CHECK p_id_del IS NOT INITIAL.

  DELETE FROM ztb_bm_teste WHERE id = p_id_del.
  IF sy-subrc = 0.
    COMMIT WORK.
    MESSAGE 'Registro deletado com sucesso' TYPE 'S'.
  ELSE.
    MESSAGE 'Falha ao deletar o registro' TYPE 'E'.
  ENDIF.
ENDFORM.

START-OF-SELECTION.
  CLEAR: p_id, p_nome.
  REFRESH it_funcionarios.