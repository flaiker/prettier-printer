"! Formatting rule base class
CLASS zcl_ppr_formatting_rule_base DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES:
      zif_ppr_formatting_rule
      ABSTRACT METHODS get_settings_group_name get_formatting_relevancy
      FINAL METHODS apply_rule.
  PROTECTED SECTION.
    METHODS:
      apply_internal ABSTRACT IMPORTING ig_settings TYPE data
                                        ir_code     TYPE REF TO stringtab.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ppr_formatting_rule_base IMPLEMENTATION.
  METHOD zif_ppr_formatting_rule~apply_rule.
    RAISE EVENT zif_ppr_formatting_rule~before_application
      EXPORTING
        code = ir_code.

    apply_internal( ig_settings = ig_settings ir_code = ir_code ).

    RAISE EVENT zif_ppr_formatting_rule~after_application
      EXPORTING
        code = ir_code.
  ENDMETHOD.
ENDCLASS.
