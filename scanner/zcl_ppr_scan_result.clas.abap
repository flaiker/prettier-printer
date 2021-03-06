"! Scan Result
CLASS zcl_ppr_scan_result DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      gty_statement_object_tab TYPE STANDARD TABLE OF REF TO zcl_ppr_scan_statement WITH DEFAULT KEY,
      gty_token_object_tab     TYPE STANDARD TABLE OF REF TO zcl_ppr_scan_token WITH DEFAULT KEY,
      gty_structure_object_tab TYPE STANDARD TABLE OF REF TO zcl_ppr_scan_structure WITH DEFAULT KEY.
    METHODS:
      set_all IMPORTING it_statements        TYPE sstmnt_tab
                        it_tokens            TYPE stokesx_tab
                        it_structures        TYPE sstruc_tab
                        it_source            TYPE stringtab
                        it_statement_objects TYPE gty_statement_object_tab
                        it_token_objects     TYPE gty_token_object_tab
                        it_structure_objects TYPE gty_structure_object_tab,
      get_statement_by_token IMPORTING io_token            TYPE REF TO zcl_ppr_scan_token
                             RETURNING VALUE(ro_statement) TYPE REF TO zcl_ppr_scan_statement,
      get_statement_by_id IMPORTING iv_id               TYPE i
                          RETURNING VALUE(ro_statement) TYPE REF TO zcl_ppr_scan_statement,
      get_token_by_id IMPORTING iv_id           TYPE i
                      RETURNING VALUE(ro_token) TYPE REF TO zcl_ppr_scan_token,
      get_structure_by_id IMPORTING iv_id               TYPE i
                          RETURNING VALUE(ro_structure) TYPE REF TO zcl_ppr_scan_structure,
      get_return_value_generic IMPORTING iv_type                TYPE string
                                         iv_id                  TYPE i
                               RETURNING VALUE(ro_return_value) TYPE REF TO zcl_ppr_scan_return_value_base,
      get_statements_by_line IMPORTING iv_line              TYPE i
                             RETURNING VALUE(rt_statements) TYPE gty_statement_object_tab,
      get_tokens_by_line IMPORTING iv_line          TYPE i
                         RETURNING VALUE(rt_tokens) TYPE gty_token_object_tab.
    DATA:
      mt_source     TYPE stringtab READ-ONLY,
      mt_statements TYPE gty_statement_object_tab READ-ONLY,
      mt_tokens     TYPE gty_token_object_tab READ-ONLY,
      mt_structures TYPE gty_structure_object_tab READ-ONLY.
  PROTECTED SECTION.
  PRIVATE SECTION.
*    DATA:
*      mt_statements        TYPE sstmnt_tab READ-ONLY,
*      mt_tokens            TYPE stokesx_tab READ-ONLY,
*      mt_structures        TYPE sstruc_tab READ-ONLY,
ENDCLASS.



CLASS zcl_ppr_scan_result IMPLEMENTATION.
  METHOD set_all.
*    mt_statements = it_statements.
*    mt_tokens = it_tokens.
*    mt_structures = it_structures.
    mt_source = it_source.
    mt_statements = it_statement_objects.
    mt_tokens = it_token_objects.
    mt_structures = it_structure_objects.
  ENDMETHOD.

  METHOD get_statement_by_token.
    DATA(lv_token_id) = line_index( mt_tokens[ table_line = io_token ] ).
    LOOP AT mt_statements INTO DATA(lo_statement).
      IF ro_statement->ms_statement-from >= lv_token_id AND
         ro_statement->ms_statement-to <= lv_token_id.
        ro_statement = lo_statement.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_statement_by_id.
    ro_statement = mt_statements[ iv_id ].
  ENDMETHOD.

  METHOD get_token_by_id.
    ro_token = mt_tokens[ iv_id ].
  ENDMETHOD.

  METHOD get_structure_by_id.
    ro_structure = mt_structures[ iv_id ].
  ENDMETHOD.

  METHOD get_return_value_generic.
    ro_return_value = SWITCH #( iv_type
      WHEN zcl_ppr_scan_statement=>gc_result_type_name
      THEN get_statement_by_id( iv_id )
      WHEN zcl_ppr_scan_token=>gc_result_type_name
      THEN get_token_by_id( iv_id )
      WHEN zcl_ppr_scan_structure=>gc_result_type_name
      THEN get_structure_by_id( iv_id )
    ).
    ASSERT ro_return_value IS BOUND.
  ENDMETHOD.

  METHOD get_statements_by_line.
    LOOP AT mt_statements INTO DATA(lo_statement).
      DATA(lv_first_line_number) = lo_statement->get_first_line_number( ).
      DATA(lv_last_line_number) = lo_statement->get_last_line_number( ).

      IF lv_first_line_number = iv_line OR
         ( lv_first_line_number < iv_line AND lv_last_line_number >= iv_line ).
        APPEND lo_statement TO rt_statements.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_tokens_by_line.
    LOOP AT mt_tokens INTO DATA(lo_token).
      IF lo_token->get_row( ) = iv_line.
        APPEND lo_token TO rt_tokens.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
