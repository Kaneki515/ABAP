*&---------------------------------------------------------------------*
*&  REPORT           zpr_bm_teste4
*&---------------------------------------------------------------------*
*& Nome:zpr_bm_teste4
*& Tipo: Report
*& Objetivo: Gerar relatório e salvar os dados em uma planilha do Excel
*& Data/Hora: Sexta, Abril 26, 2024 (GMT-3) - 10:15
*& Desenvolvedor: Bruno Misufara (Infinitfy)
*&---------------------------------------------------------------------*
*& Versão 1: Bruno Misufara - Desenvolvimento - NPLK900120
*& Versão 2: ?
*& Versão 3: ?
*&---------------------------------------------------------------------*
REPORT zpr_bm_teste4.

***************
***	 TYPES  ***
***************
TYPES: BEGIN OF ty_user,
         id          TYPE ztb_bm_teste-id,
         nome        TYPE ztb_bm_teste-nome,
         sobrenome   TYPE ztb_bm_teste-sobrenome,
         numero      TYPE ztb_bm_adress-numero,
         cep         TYPE ztb_bm_adress-cep,
         cidade      TYPE ztb_bm_adress-cidade,
         uf          TYPE ztb_bm_adress-uf,
         rua         TYPE ztb_bm_adress-rua,
         bairro      TYPE ztb_bm_adress-bairro,
         logradouro  TYPE ztb_bm_adress-logradouro,
         complemento TYPE ztb_bm_adress-complemento,
       END OF ty_user.

******************
*** VARIÁVEIS  ***
******************
DATA: g_str2  TYPE string.
DATA: g_ext TYPE string.

DATA: ifiletable TYPE filetable.
DATA: xfiletable LIKE LINE OF ifiletable.
DATA: rc TYPE i.

DATA : BEGIN OF it_header OCCURS 0,
         line(50) TYPE c,
       END OF it_header.

***************************************
*** PARAMETROS DE SELEÇÃO DE DADOS  ***
***************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS: p_file(10) TYPE c. "Nome do arquivo

PARAMETERS: p_dir_lg  TYPE localfile DEFAULT TEXT-001. "Campo que pede o Local onde será salvo.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS: rb_txt  RADIOBUTTON GROUP rb1 USER-COMMAND rb DEFAULT 'X',
            rb_xlsx RADIOBUTTON GROUP rb1.
SELECTION-SCREEN END OF BLOCK b2.

START-OF-SELECTION.
  it_header-line = 'ID'.
  APPEND it_header.
  it_header-line = 'Nome'.
  APPEND it_header.
  it_header-line = 'Sobrenome'.
  APPEND it_header.
  it_header-line = 'CEP'.
  APPEND it_header.
  it_header-line = 'Rua'.
  APPEND it_header.
  it_header-line = 'Bairro'.
  APPEND it_header.
  it_header-line = 'Cidade'.
  APPEND it_header.
  it_header-line = 'Número'.
  APPEND it_header.
  it_header-line = 'UF'.
  APPEND it_header.
  it_header-line = 'Logradouro'.
  APPEND it_header.
  it_header-line = 'Complemento'.
  APPEND it_header.

  IF rb_txt = 'X'.
    g_ext = '.txt'.
  ELSEIF rb_xlsx = 'X'.
    g_ext = '.xlsx'.
  ENDIF.

  PERFORM zf_select.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_dir_lg.
  PERFORM z_local USING p_dir_lg.

*--------------------------------------------------------*
*                       Form  Z_LOCAL                    *
*--------------------------------------------------------*
*   SELECIONA O LOCAL ONDE O ARQUIVO SERÁ ARMAZENADO     *
*--------------------------------------------------------*
FORM z_local  USING p_dir TYPE localfile.

  DATA: l_sel_dir     TYPE string.

  CALL METHOD cl_gui_frontend_services=>directory_browse "Metodo que abre o pop-up de selecionar o diretorio
*     EXPORTING
*       WINDOW_TITLE        =
*      INITIAL_FOLDER       =
    CHANGING
      selected_folder      = l_sel_dir
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.
  IF sy-subrc <> 0.
*    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    p_dir = l_sel_dir."Passa o caminho do diretorio para o parametro
  ENDIF.
ENDFORM.

*--------------------------------------------------------*
*                   Form  ZF_SELECT                      *
*--------------------------------------------------------*
*   SELECIONA OS DADOS A SEREM PASSADOS AOS ARQUIVOS     *
*--------------------------------------------------------*
FORM zf_select.
  SELECT
    teste~id,
    teste~nome,
    teste~sobrenome,
    address~cep,
    address~rua,
    address~bairro,
    address~cidade,
    address~numero,
    address~uf,
    address~logradouro,
    address~complemento
  FROM ztb_bm_teste AS teste
  INNER JOIN ztb_bm_adress AS address ON teste~number_address = address~number_address
  INTO TABLE @DATA(it_user).

  PERFORM zf_converter TABLES it_user.
ENDFORM.

*--------------------------------------------------------*
*                   Form  ZF_CONVERTER                   *
*--------------------------------------------------------*
*   pASSA OS VALORES PARA O ARQUIVO TIPO DE ARQUIVO      *
*                      SELECIONADO                       *
*--------------------------------------------------------*
FORM zf_converter  TABLES    p_it_user.

  IF sy-subrc <> 0.

    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno

    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ENDIF.


  IF p_file NS '.'.
    CONCATENATE p_dir_lg p_file INTO g_str2 SEPARATED BY '\'.
    CONCATENATE g_str2 g_ext INTO g_str2.
  ELSE.
    g_str2 = p_file.
  ENDIF.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
*     BIN_FILESIZE                    =
      filename   = g_str2
      filetype   = 'DAT'
*     APPEND     = ' '
*     WRITE_FIELD_SEPARATOR           = ' '
*     HEADER     = '00'
*     TRUNC_TRAILING_BLANKS           = ' '
*     WRITE_LF   = 'X'
*     COL_SELECT = ' '
*     COL_SELECT_MASK                 = ' '
*     DAT_MODE   = ' '
*     CONFIRM_OVERWRITE               = ' '
*     NO_AUTH_CHECK                   = ' '
*     CODEPAGE   = ' '
*     IGNORE_CERR                     = ABAP_TRUE
*     REPLACEMENT                     = '#'
*     WRITE_BOM  = ' '
*     TRUNC_TRAILING_BLANKS_EOL       = 'X'
*     WK1_N_FORMAT                    = ' '
*     WK1_N_SIZE = ' '
*     WK1_T_FORMAT                    = ' '
*     WK1_T_SIZE = ' '
*     WRITE_LF_AFTER_LAST_LINE        = ABAP_TRUE
*     SHOW_TRANSFER_STATUS            = ABAP_TRUE
*     VIRUS_SCAN_PROFILE              = '/SCET/GUI_DOWNLOAD'
* IMPORTING
*     FILELENGTH =
    TABLES
      data_tab   = p_it_user
      fieldnames = it_header
* EXCEPTIONS
*     FILE_WRITE_ERROR                = 1
*     NO_BATCH   = 2
*     GUI_REFUSE_FILETRANSFER         = 3
*     INVALID_TYPE                    = 4
*     NO_AUTHORITY                    = 5
*     UNKNOWN_ERROR                   = 6
*     HEADER_NOT_ALLOWED              = 7
*     SEPARATOR_NOT_ALLOWED           = 8
*     FILESIZE_NOT_ALLOWED            = 9
*     HEADER_TOO_LONG                 = 10
*     DP_ERROR_CREATE                 = 11
*     DP_ERROR_SEND                   = 12
*     DP_ERROR_WRITE                  = 13
*     UNKNOWN_DP_ERROR                = 14
*     ACCESS_DENIED                   = 15
*     DP_OUT_OF_MEMORY                = 16
*     DISK_FULL  = 17
*     DP_TIMEOUT = 18
*     FILE_NOT_FOUND                  = 19
*     DATAPROVIDER_EXCEPTION          = 20
*     CONTROL_FLUSH_ERROR             = 21
*     OTHERS     = 22
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.