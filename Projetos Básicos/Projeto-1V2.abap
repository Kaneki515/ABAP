REPORT zpr_bm_teste2.

TABLES: ztb_bm_teste, sscrfields.

TYPES: BEGIN OF ty_funcionarios,
         id   TYPE ztb_bm_teste-id,
         nome TYPE ztb_bm_teste-nome,
       END OF ty_funcionarios.


DATA: it_funcionarios TYPE TABLE OF ztb_bm_teste,
      wa_funcionario  TYPE ztb_bm_teste,
      gv_tab          TYPE string.


SELECTION-SCREEN BEGIN OF TABBED BLOCK aba FOR 10 LINES.
SELECTION-SCREEN TAB (20) tab_cre USER-COMMAND tela_create DEFAULT SCREEN 100.
SELECTION-SCREEN TAB (20) tab_red USER-COMMAND tela_read DEFAULT SCREEN 101.
SELECTION-SCREEN TAB (20) tab_upd USER-COMMAND tela_update DEFAULT SCREEN 102.
SELECTION-SCREEN TAB (20) tab_del USER-COMMAND tela_delete DEFAULT SCREEN 103.
SELECTION-SCREEN END OF BLOCK aba.

* Aba para a tela de create user.
SELECTION-SCREEN BEGIN OF SCREEN 100 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_id   TYPE ztb_bm_teste-id,
            p_nome TYPE ztb_bm_teste-nome.
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN END OF SCREEN 100.

* Aba para a tela de Read user.
SELECTION-SCREEN BEGIN OF SCREEN 101 AS SUBSCREEN.

SELECTION-SCREEN END OF SCREEN 101.

* Aba para a tela de update user.
SELECTION-SCREEN BEGIN OF SCREEN 102 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-003.
PARAMETERS: p_id_up  TYPE ztb_bm_teste-id,
            p_nom_up TYPE ztb_bm_teste-nome.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF SCREEN 102.

* Aba para a tela de delete user.
SELECTION-SCREEN BEGIN OF SCREEN 103 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-004.
PARAMETERS: p_id_del TYPE ztb_bm_teste-id.
CHECK p_id_del IS NOT INITIAL.
SELECTION-SCREEN END OF BLOCK b3.
SELECTION-SCREEN END OF SCREEN 103.


INITIALIZATION.
*Telas
  tab_cre = 'Create'.
  tab_red = 'Read'.
  tab_upd = 'Update'.
  tab_del = 'Delete'.

  aba-prog = sy-repid.

START-OF-SELECTION.

  CASE sy-ucomm.
    WHEN 'tela_create'.
      aba-activetab = 'tela_create'.
      aba-dynnr = 100.
    WHEN 'tela_read'.
      aba-activetab = 'tela_read'.
      aba-dynnr = 101.
    WHEN 'tela_update'.
      aba-activetab = 'tela_update'.
      aba-dynnr = 102.
    WHEN 'tela_delete'.
      aba-activetab = 'tela_delete'.
      aba-dynnr = 103.
  ENDCASE.

  CASE aba-activetab.
    WHEN 'TELA_CREATE'.
      PERFORM fm_create_user.
    WHEN 'TELA_READ'.
      PERFORM fm_read_user.
      RETURN.
    WHEN 'TELA_UPDATE'.
      PERFORM fm_update_user.
    WHEN 'TELA_DELETE'.
      PERFORM fm_delete_user.
  ENDCASE.


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

  SELECT mandt, id, nome FROM ztb_bm_teste INTO TABLE @it_funcionarios.

  DATA: o_alv TYPE REF TO cl_salv_table.

  TRY.
      cl_salv_table=>factory( IMPORTING r_salv_table = o_alv
                            CHANGING  t_table      = it_funcionarios ).

      o_alv->get_functions( )->set_all( abap_true ).

      o_alv->get_display_settings( )->set_list_header( 'Funcionarios Cadastrados' ).

      o_alv->display( ).

    CATCH cx_salv_msg INTO DATA(o_exception).
      MESSAGE 'Erro ao gerar o relatório ALV' TYPE 'I'.
  ENDTRY.



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