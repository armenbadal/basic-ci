
%token T_DECLARE
%token T_FUNCTION
%token T_END
%token T_LET
%token T_INPUT
%token T_PRINT
%token T_IF T_THEN T_ELSEIF T_ELSE
%token T_FOR T_TO T_STEP
%token T_WHILE
%token T_CALL

%token T_EOL

%left T_OR
%left T_AND
%nonassoc T_EQ T_NE
%nonassoc T_GT T_GE T_LT T_LE
%left T_ADD T_SUB
%left T_MUL T_DIV
%right T_POW
%right T_NOT

%token T_IDENT
%token T_REAL
%token T_TEXT

%start Program
%%
Program
    : FunctionList
    ;

FunctionList
    : FunctionList Function
    | %empty
    ;

Function
    : Declaration
    | Definition
    ;

Declaration
    : T_DECLARE FunctionHeader
    ;

Definition
    : FunctionHeader StatementList T_END T_FUNCTION
    ;

FunctionHeader
    : T_FUNCTION T_IDENT '(' ParameterList ')' NewLines
    ;

ParameterList
    : IdentifierList
    | %empty
    ;

IdentifierList
    : IdentifierList ',' T_IDENT
    | T_IDENT
    ;

NewLines
    : NewLines T_EOL
    | T_EOL
    ;

StatementList
    : StatementList Statement NewLines
    | %empty
    ;

Statement
    : LetOpt T_IDENT T_EQ Expression
    | T_INPUT T_IDENT
    | T_PRINT Expression
    | T_IF Expression T_THEN NewLines StatementList
      ElseIfPartList ElsePart T_END T_IF
    | T_FOR T_IDENT T_EQ Expression T_TO Expression StepOpt NewLines
      StatementList T_END T_FOR
    | T_WHILE Expression NewLines StatementList T_END T_WHILE
    | T_CALL T_IDENT ArgumentList
    ;

LetOpt
    : T_LET
    | %empty
    ;

ElseIfPartList
    : T_ELSEIF Expression T_THEN NewLines StatementList ElseIfPartList
    | %empty
    ;
ElsePart
    : T_ELSE NewLines StatementList
    | %empty
    ;

StepOpt
    : T_STEP T_REAL
    | T_STEP T_SUB T_REAL
    | %empty
    ;

ArgumentList
    : ExpressionList
    | %empty
    ;

ExpressionList
    : ExpressionList ',' Expression
    | Expression
    ;

Expression
    : Expression T_OR Expression
    | Expression T_AND Expression
    | Expression T_EQ Expression
    | Expression T_NE Expression
    | Expression T_GT Expression
    | Expression T_GE Expression
    | Expression T_LT Expression
    | Expression T_LE Expression
    | Expression T_ADD Expression
    | Expression T_SUB Expression
    | Expression T_MUL Expression
    | Expression T_DIV Expression
    | Expression T_POW Expression
    | T_IDENT '(' ArgumentList ')'
    | '(' Expression ')'
    | T_SUB Expression %prec T_NOT
    | T_NOT Expression
    | T_IDENT
    | T_REAL
    | T_TEXT
    ;

