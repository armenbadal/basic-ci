
%token T_ADD
%token T_AND
%token T_CALL
%token T_DECLARE
%token T_DIV
%token T_ELSE
%token T_ELSEIF
%token T_END
%token T_EOL
%token T_EQ
%token T_FOR
%token T_FUNCTION
%token T_GE
%token T_GT
%token T_IDENT
%token T_IF
%token T_INPUT
%token T_LE
%token T_LET
%token T_LT
%token T_MUL
%token T_NE
%token T_NOT
%token T_OR
%token T_POW
%token T_PRINT
%token T_REAL
%token T_STEP
%token T_SUB
%token T_TEXT
%token T_THEN
%token T_TO
%token T_WHILE

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
    : Let
    | Input
    | Print
    | If
    | For
    | While
    | Call
    ;

Let
    :  LetOpt T_IDENT T_EQ Disjunction
    ;
LetOpt
    : T_LET
    | %empty
    ;

Input
    : T_INPUT T_IDENT
    ;

Print
    : T_PRINT Disjunction
    ;

If
    : T_IF Disjunction T_THEN NewLines StatementList
      ElseIfPartList ElsePart T_END T_IF
    ;
ElseIfPartList
    : T_ELSEIF Disjunction T_THEN NewLines StatementList ElseIfPartList
    | %empty
    ;
ElsePart
    : T_ELSE NewLines StatementList
    | %empty
    ;

For
    : T_FOR T_IDENT T_EQ Disjunction T_TO Disjunction StepOpt NewLines
      StatementList T_END T_FOR
    ;
StepOpt
    : T_STEP T_REAL
    | T_STEP T_SUB T_REAL
    | %empty
    ;

While
    : T_WHILE Disjunction NewLines StatementList T_END T_WHILE
    ;

Call
    : T_CALL T_IDENT ArgumentList
    ;

ArgumentList
    : ExpressionList
    | %empty
    ;

ExpressionList
    : ExpressionList ',' Disjunction
    | Disjunction
    ;

Disjunction
    : Disjunction T_OR Conjunction
    | Conjunction
    ;

Conjunction
    : Conjunction T_AND Equality
    | Equality
    ;

Equality
    : Comparison EqualOp Comparison
    | Comparison
    ;
EqualOp
    : T_EQ
    | T_NE
    ;

Comparison
    : Addition CompOp Addition
    | Addition
    ;
CompOp
    : T_GT
    | T_GE
    | T_LT
    | T_LE
    ;

Addition
    : Addition AddOp Multiplication
    | Multiplication
    ;
AddOp
    : T_ADD
    | T_SUB
    ;

Multiplication
    : Multiplication MulOp Exponentation
    | Exponentation
    ;
MulOp
    : T_MUL
    | T_DIV
    ;

Exponentation
    : Primary T_POW Exponentation
    | Primary
    ;

Primary
    : T_IDENT '(' ArgumentList ')'
    | '(' Disjunction ')'
    | T_SUB Primary
    | T_NOT Primary
    | Factor
    ;

Factor
    : T_REAL
    | T_TEXT
    | T_IDENT
    ;

