*&---------------------------------------------------------------------*
*& Report ZPR_BM_CRUD
*&---------------------------------------------------------------------*
*& 1. Cadastro Simples de Funcionários
*&---------------------------------------------------------------------*
REPORT zpr_bm_crud.

INITIALIZATION.
*Chama a tabela transparente.
  TABLES: ztb_bm_teste.

  DATA: it_pessoas TYPE TABLE OF ztb_bm_teste, "Determina que a estrutura da tabela interna
        wa_pessoa  TYPE ztb_bm_teste, "Determina que a work area segue a linha do tipo ty_pessoa.
        list       TYPE vrm_values,
        lv_id      TYPE string,
        value      LIKE LINE OF list.

*  SELECT * FROM ztb_bm_teste INTO TABLE it_pessoas.

*  cl_demo_output=>display( it_pessoas ).

*Cria os radio buttons. Definindo que perticipam do grupo gr1 e o p_create é o botão padrão.
  PARAMETERS: p_create RADIOBUTTON GROUP gr1 DEFAULT 'X' USER-COMMAND uc,
              p_read   RADIOBUTTON GROUP gr1,
              p_update RADIOBUTTON GROUP gr1,
              p_delete RADIOBUTTON GROUP gr1.

*Criação das telas para os campos.
  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_nome  TYPE ztb_bm_teste-nome MODIF ID gr2,
              p_sobre TYPE ztb_bm_teste-sobrenome MODIF ID gr2,
              p_cep   TYPE ztb_bm_teste-cep MODIF ID gr2.
  SELECTION-SCREEN END OF BLOCK b1.

  SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-003.
  PARAMETERS: p_id_up  TYPE ztb_bm_teste-id MODIF ID gr3,
              p_nom_up TYPE ztb_bm_teste-nome MODIF ID gr3,
              p_sob_up TYPE ztb_bm_teste-sobrenome MODIF ID gr3,
              p_cep_up TYPE ztb_bm_teste-cep MODIF ID gr3.
  SELECTION-SCREEN END OF BLOCK b2.

  SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-004.
  PARAMETERS: p_id_del TYPE ztb_bm_teste-id MODIF ID gr4.
  SELECTION-SCREEN END OF BLOCK b3.

*  chama o form da seção do qual está selecionado.

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

  CLEAR p_nome.
  CLEAR p_sobre.
  CLEAR p_cep.

  CLEAR p_id_up.
  CLEAR p_nom_up.
  CLEAR p_sob_up.
  CLEAR p_cep_up.

  CLEAR p_id_del.

  LOOP AT SCREEN.
    IF p_create = 'X'.
      IF screen-group1 = 'GR2'.
        screen-active = 1.
      ELSEIF screen-group1 = 'GR4' OR screen-group1 = 'GR3'.
        screen-active = 0.
      ENDIF.

    ELSEIF p_read = 'X'.
      IF screen-group1 = 'GR4' OR screen-group1 = 'GR3' OR screen-group1 = 'GR2'.
        screen-active = 0.
      ENDIF.

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

*  Chama o performa de read_user quando o botão p_read é selecionado.
  IF p_read = 'X'.
    PERFORM fm_read_user.
  ENDIF.



  " Form para cadastro de pessoa.
*&---------------------------------------------------------------------*
FORM fm_create_user.

  "Passa o valores pegos no respectivos campos da work area.
  wa_pessoa-nome = p_nome.
  wa_pessoa-sobrenome = p_sobre.
  wa_pessoa-cep = p_cep.

  SELECT SINGLE MAX( id )
    FROM ztb_bm_teste
    INTO @DATA(max_id). " Realiza um busco do maior id da tabela

  max_id = max_id + 1. " Realiza a soma do maior id + 1.

  wa_pessoa-id = max_id. "Passa o valor de max_id + 1 para o id da work area.

  APPEND wa_pessoa TO it_pessoas.

*  INSERT INTO ztb_bm_teste VALUES it_pessoas. "Inserir valor da work area para a tabela.

  MODIFY ztb_bm_teste FROM TABLE it_pessoas. "Inserir os dados com base em uma tabela interna.

  IF sy-subrc <> 0.
    MESSAGE 'Erro ao inserir o registro' TYPE 'E'.
  ELSE.
    COMMIT WORK.
    MESSAGE 'Registro inserido com sucesso' TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*

*Form para exibir os registros cadastrados.
*&---------------------------------------------------------------------*
FORM fm_read_user.

  SELECT mandt, id, nome, sobrenome, cep FROM ztb_bm_teste INTO TABLE @it_pessoas.

  DATA: o_alv TYPE REF TO cl_salv_table.

  TRY.
      cl_salv_table=>factory( IMPORTING r_salv_table = o_alv
                            CHANGING  t_table      = it_pessoas ).

      o_alv->get_functions( )->set_all( abap_true ).

      o_alv->get_display_settings( )->set_list_header( 'Pessoas Cadastradas' ).

      o_alv->display( ).

    CATCH cx_salv_msg INTO DATA(o_exception).
      MESSAGE 'Erro ao gerar o relatório ALV' TYPE 'I'.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*

*Form para Update.
*&---------------------------------------------------------------------*
FORM fm_update_user.
  DATA: lv_nome  TYPE ztb_bm_teste-nome,
        lv_sobre TYPE ztb_bm_teste-sobrenome,
        lv_cep   TYPE ztb_bm_teste-cep.
  SELECT SINGLE * FROM ztb_bm_teste INTO wa_pessoa WHERE id = p_id_up.

  IF sy-subrc = 0.

    lv_nome = wa_pessoa-nome.
    lv_sobre = wa_pessoa-sobrenome.
    lv_cep = wa_pessoa-cep.

* Atribui os valores das variáveis aos campos da estrutura wa_pessoa
    wa_pessoa-nome = p_nom_up.
    wa_pessoa-sobrenome = p_sob_up.
    wa_pessoa-cep = p_cep_up.

    IF p_nom_up IS INITIAL.
      wa_pessoa-nome = lv_nome.
    ENDIF.
    IF p_sob_up IS INITIAL.
      wa_pessoa-sobrenome = lv_sobre.
    ENDIF.
    IF p_cep_up IS INITIAL.
      wa_pessoa-cep = lv_cep.
    ENDIF.


* Atualiza os campos da estrutura wa_pessoa com os valores das variáveis
    MODIFY ztb_bm_teste FROM wa_pessoa.
    BREAK-POINT.
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

*&---------------------------------------------------------------------*

* Fomr para Delete.
*&---------------------------------------------------------------------*
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
*&---------------------------------------------------------------------*