
space                               [ /t/n]+
digit                               [0-9]
sign                                [-+]
%token letter                             
%token STRING_LITERAL
%token URLSTRING 
%start program

%token INT_LITERAL 
%token FLOAT_LITERAL 
%token NONSTOP
%token TIME_FUNC
%token LOG_FUNC
%token ERROR_FUNC
%token kw_F
%token SWITCH 
%token TYPE
%token IF
%token ELSE
%token FOR
%token WHILE 
%token RP
%token LP
%token LCB
%token RCP
%token LSB
%token RSP
%token LEQ
%token LNOT
%token LAND
%token LOR
%token LT
%token GT
%token LTE
%token GTE
%token INN
%token OUT
%token PLUS
%token MINUS
%token MUL
%token DIV
%token EQ
%token SEMICOLON


{identifier}                        {LOG(" IDENTIFIER "); ECHO; LOG(">");}
{comment}                           {;}
{space}                             {;}
.^/n                                {LOG("WHAt/n");}
    %%
    
    program = stmt_list;
    stmt_list = stmt 
		| stmt_list stmt;
    stmt ::= matched_stmt 
		| unmatched_stmt;
    matched_stmt ::= declaration_stmt 
		| assign_stmt
		| init_stmt 
		| matched_if_stmt 
		| loop_stmt;
    matched_stmt_list ::=  matched_stmt 
		| matched_stmt_list matched_stmt;
    unmatched_stmt ::= unmatched_if_stmt;
    unmatched_stmt_list ::=  unmatched_stmt; 
		| unmatched_stmt_list unmatched_stmt;
    declaration_stmt ::= funct_declaration 
		| var_declaration;
    var_declaration_list ::= var_declaration 
		| var_declaration_list var_declaration
    var_declaration ::= type identifier;

    funct_declaration ::= function identifier(var_declaration_list)  type> { stmt_list };

    assign_stmt ::= special_assign 
		| conventional_assign;
    special_assign ::= input_assign 
		| output_assign;
    input_assign ::= identifier << identifier 
		| identifier << sensor_expr 
		| nonstop identifier << identifier;
    output_assign ::= identifier >> expr 
		| switch_type >> logic_expr;
    conventional_assign ::= identifier = expr;

    init_stmt ::= type assign_stmt;

    matched_if_stmt ::= if (logic_expr) matched_stmt else matched_stmt 
                    | if (logic_expr) {matched_stmt_list} else {matched_stmt_list}
                    | if (logic_expr) matched_stmt else matched_stmt
                    | if (logic_expr) {matched_stmt_list} else matched_stmt;

   unmatched_if_stmt ::= if (logic_expr) matched_stmt else unmatched_stmt 
                    | if (logic_expr) {matched_stmt_list} else {unmatched_stmt_list }
                    | if (logic_expr) matched_stmt else unmatched_stmt
                    | if (logic_expr) {matched_stmt_list} else unmatched_stmt
                    | if (logic_expr) stmt
                    | if (logic_expr) {stmt_list};
   
    loop_stmt ::= while_stmt 
		    | for_stmt; 
    while_stmt ::= while (logic_expr) stmt 
		    |  while (logic_expr) {stmt_list}; 
    for_stmt ::= for (init_stmt?; logic_expr?; arithmetic_expr;) stmt 
                    |for (init_stmt?; logic_expr?; arithmetic_expr;) {stmt_list};


    expr ::= logic_expr 
		| arithmetic_expr
		| url_expr 
		| sensor_expr 
		| literal_expr 
		| time_expr 
		| func_call_expr;

    logic_expr ::= logic_operand binlog_operator logic_operand 
		| unilog_operator ? logic_operand
    binlog_operator ::=  == 
		| & 
		| "|";
    unilog_operator ::=  !
    logic_operand  ::= logic_expr 
		| identifier 
		| bool_literal;
    arithmetic_expr ::= art_operand add_sub term_operand 
		| term_operand;
    term_operand ::= term_operand mul_div factor_operand 
		| factor_operand;
    factor_operand ::= ( arithmetic_expr ) 
		| identifier;
    add_sub ::= + | -;
    mul_div ::= * | /;

    art_operand ::=  integer_literal  
		|  float_literal  
		|  string_literal  
		|  identifier;

     url_expr  ::= ' chars ';

     sensor_expr  ::= TEMP( arithmetic_expr ) | HUM( arithmetic_expr ) | AIRPRES( arithmetic_expr ) | AIRQUAL( arithmetic_expr ) | LIGHT( arithmetic_expr ) | SOUND( arithmetic_expr );

     literal_expr  ::=  bool_literal  |  integer_literal  |  float_literal  |  string_literal;
         bool_literal  ::= true | false;
         integer_literal  ::=  sign ?  digits;
         digits  ::=  digit  |  digits   digit;
         digit  ::= 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0;
         float_literal  ::=  sign ?  digits  .  digits;
         string_literal  ::= " chars ";
         chars  ::=  letter   chars ;
		|  digit   chars  
		|  letter  
		|  digit;
 
         letter  ::= [A-Za-z]+? # TODO #
         sign  ::= - | +;

     time_expr  ::= time();

     func_call_expr  ::=  identifier ( parameter_list ?);
     parameter_list  ::=  parameter  
		|  parameter_list   parameter , ;
     parameter  ::=  identifier;


 identifier  ::=  letter   digits ?;


 type  ::= INT | BOOL | FLOAT | URL | SENSOR | STRING;
 switch_type  ::= SW1 | SW2 | SW3 | SW4 | SW5 | SW6 | SW7 | SW8 | SW9 | SW10;
    %%
    #include "lex.yy.c"

    ...additional user code...

    main() {
      return yyparse();
    }
    int yyerror( char *s ) { fprintf( stderr, "%s\n", s); }
    
