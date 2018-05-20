"! Statement factory
CLASS zcl_ppr_statement_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS:
      get_statement_from_scan IMPORTING io_scan_statement   TYPE REF TO zcl_ppr_scan_statement
                              RETURNING VALUE(ro_statement) TYPE REF TO zcl_ppr_statement.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ppr_statement_factory IMPLEMENTATION.
  METHOD get_statement_from_scan.
    CASE io_scan_statement->get_structure( )->get_structure_type( ).
      WHEN zcl_ppr_constants=>gc_scan_struc_types-alternation.
        ro_statement = NEW zcl_ppr_stmnt_condition( io_scan_statement ).
*      WHEN zcl_ppr_constants=>gc_scan_stmnt_types-standard.

      WHEN OTHERS.
        ro_statement = NEW #( io_scan_statement ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.