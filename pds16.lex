/* -----------------------------------------------------------------------------
	secção de código de utilizador
*/

import java_cup.runtime.*;

%%

/* -----------------------------------------------------------------------------
	secção de opções e declarações
*/

%class Lexer
%standalone
%8bit
%line
%column
%cup

%debug

%{
	StringBuffer string = new StringBuffer();

	private Symbol symbol(int type) {
		return new Symbol(type, yyline, yycolumn);
	}

	private Symbol symbol(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = { LineTerminator } | [ \t\f]

/* comments */

Comment =	{TraditionalComment} | {EndOfLineComment1} |
			{EndOfLineComment2} | {DocumentationComment}

TraditionalComment = "/*" [^*] ~"*/" | "/*" "*"+ "/"

// Comment can be the last line of the file, without line terminator.
EndOfLineComment1 = "//" {InputCharacter}* {LineTerminator}?
EndOfLineComment2 = ";" {InputCharacter}* {LineTerminator}?

DocumentationComment = "/**" {CommentContent} "*"+ "/"

CommentContent = ( [^*] | \*+ [^/*] )*

Identifier = [:jletter:] [:jletterdigit:]*

/* integer literals */
DecIntegerLiteral = 0 | [1-9][0-9]*

HexIntegerLiteral = 0 [xX] 0* {HexDigit} {1,8}
HexDigit          = [0-9a-fA-F]

OctIntegerLiteral = 0+ [1-3]? {OctDigit} {1,15}
OctDigit          = [0-7]

BinIntegerLiteral = 0 [bB] 0* {BinDigit} {1,32}
BinDigit          = [0-1]

Label = [:jletterdigit:] [:jletterdigit:]* ":"

%state STRING
%state CHARLITERAL
     
%%
/* -----------------------------------------------------------------------------
	secção de opções e declarações
*/

<YYINITIAL> {
	"."					{ return symbol(sym.DOT); }
	"section"			{ return symbol(sym.SECTION); }
	"text"				{ return symbol(sym.TEXT); }
	"data"				{ return symbol(sym.DATA); }
	"equ"				{ return symbol(sym.EQU); }
	"set"				{ return symbol(sym.EQU); }
	"org"				{ return symbol(sym.ORG); }
	"end"				{ return symbol(sym.END); }
	"byte"				{ return symbol(sym.BYTE); }
	"word"				{ return symbol(sym.WORD); }
	"space"				{ return symbol(sym.SPACE); }
	"ascii"				{ return symbol(sym.ASCII); }

	/* numeric literals */
	{DecIntegerLiteral}	{ return symbol(sym.INTEGER_LITERAL); }
	{HexIntegerLiteral}	{ return symbol(sym.INTEGER_LITERAL); }
	{OctIntegerLiteral}	{ return symbol(sym.INTEGER_LITERAL); }
	{BinIntegerLiteral}	{ return symbol(sym.INTEGER_LITERAL); } 

	/* string literal */
	\"					{ string.setLength(0); yybegin(STRING); }

	/* character literal */
	\'					{ yybegin(CHARLITERAL); }

	/* operators */
	"low"				{ return symbol(sym.LOW); }
	"high"				{ return symbol(sym.HIGH); }
	"="					{ return symbol(sym.EQUAL); }
	"=="				{ return symbol(sym.EQUAL_EQUAL); }
	"!="				{ return symbol(sym.NOT_EQUAL); }
	"<"					{ return symbol(sym.LESSER); }
	"<="				{ return symbol(sym.LESSER_EQUAL); }
	">"					{ return symbol(sym.GREATER); }
	">="				{ return symbol(sym.GREATER_EQUAL); }
	">>"				{ return symbol(sym.SHIFT_RIGHT); }
	"<<"				{ return symbol(sym.SHIFT_LEFT); }
	":"					{ return symbol(sym.COLON); }
	";"					{ return symbol(sym.SEMICOLON); }
	","					{ return symbol(sym.COMMA); }
	"&"					{ return symbol(sym.AMPERSAND); }
	"|"					{ return symbol(sym.PIPE); }
	"^"					{ return symbol(sym.CIRCUMFLEX); }
	"~"					{ return symbol(sym.TILDE); }
	"&&"				{ return symbol(sym.AMPERSAND_AMPERSAND); }
	"||"				{ return symbol(sym.PIPE_PIPE); }
	"!"					{ return symbol(sym.EXCLAMATION); }
	"?"					{ return symbol(sym.QUESTION); }
	"("					{ return symbol(sym.PARENTHESE_LEFT); }
	")"					{ return symbol(sym.PARENTHESE_RIGHT); }
	"["					{ return symbol(sym.BRACKET_LEFT); }
	"]"					{ return symbol(sym.BRACKET_RIGHT); }
	"#"					{ return symbol(sym.CARDINAL); }
	"*"					{ return symbol(sym.ASTERISK); }
	"/"					{ return symbol(sym.SLASH); }
	"%"					{ return symbol(sym.PERCENT); }
	"+"					{ return symbol(sym.PLUS); }
	"-"					{ return symbol(sym.MINUS); }

	/* register */
	"r0"				{return symbol(sym.REGISTER); }
	"R0"				{return symbol(sym.REGISTER); }
	"r1"				{return symbol(sym.REGISTER); }
	"R1"				{return symbol(sym.REGISTER); }
	"r2"				{return symbol(sym.REGISTER); }
	"R2"				{return symbol(sym.REGISTER); }
	"r3"				{return symbol(sym.REGISTER); }
	"R3"				{return symbol(sym.REGISTER); }
	"r4"				{return symbol(sym.REGISTER); }
	"R4"				{return symbol(sym.REGISTER); }
	"r5"				{return symbol(sym.REGISTER); }
	"R5"				{return symbol(sym.REGISTER); }
	"lr"				{return symbol(sym.REGISTER); }
	"LR"				{return symbol(sym.REGISTER); }
	"r6"				{return symbol(sym.REGISTER); }
	"R6"				{return symbol(sym.REGISTER); }
	"r7"				{return symbol(sym.REGISTER); }
	"R7"				{return symbol(sym.REGISTER); }
	"pc"				{return symbol(sym.REGISTER); }
	"PC"				{return symbol(sym.REGISTER); }

	/* instructions */

	"ldi"				{ return symbol(sym.LDI); }
	"ldih"				{ return symbol(sym.LDI); }
	"ld"				{ return symbol(sym.LD); }
	"ldb"				{ return symbol(sym.LD); }
	"st"				{ return symbol(sym.ST); }
	"stb"				{ return symbol(sym.ST); }

	"add"				{ return symbol(sym.ADD); }
	"addf"				{ return symbol(sym.ADD); }
	"adc"				{ return symbol(sym.ADC); }
	"adcf"				{ return symbol(sym.ADC); }
	"sub"				{ return symbol(sym.SUB); }
	"subf"				{ return symbol(sym.SUB); }
	"sbb"				{ return symbol(sym.SBB); }
	"sbbf"				{ return symbol(sym.SBB); }

	"anl"				{ return symbol(sym.AND); }
	"anlf"				{ return symbol(sym.AND); }
	"orl"				{ return symbol(sym.OR); }
	"orlf"				{ return symbol(sym.OR); }
	"xrl"				{ return symbol(sym.XOR); }
	"xrlf"				{ return symbol(sym.XOR); }
	"not"				{ return symbol(sym.NOT); }
	"notf"				{ return symbol(sym.NOT); }
	"shl"				{ return symbol(sym.SHL); }
	"shr"				{ return symbol(sym.SHR); }
	"rrm"				{ return symbol(sym.RR); }
	"rrl"				{ return symbol(sym.RR); }
	"rcl"				{ return symbol(sym.RC); }
	"rcr"				{ return symbol(sym.RC); }

	"mov"				{ return symbol(sym.MOV); }
	"movf"				{ return symbol(sym.MOV); }

	"inc"				{ return symbol(sym.INC); }
	"incf"				{ return symbol(sym.INC); }

	"dec"				{ return symbol(sym.DEC); }
	"decf"				{ return symbol(sym.DEC); }

	"jz"				{ return symbol(sym.JZ); }
	"je"				{ return symbol(sym.JZ); }
	"jnz"				{ return symbol(sym.JNZ); }
	"jne"				{ return symbol(sym.JNZ); }
	"jc"				{ return symbol(sym.JC); }
	"jbl"				{ return symbol(sym.JC); }
	"jnc"				{ return symbol(sym.JNC); }
	"jae"				{ return symbol(sym.JNC); }
	"jmp"				{ return symbol(sym.JMP); }
	"jmpl"				{ return symbol(sym.JMP); }
	"ret"				{ return symbol(sym.RET); }
	"iret"				{ return symbol(sym.IRET); }
	"nop"				{ return symbol(sym.NOP); }

	{Label}				{ return symbol(sym.LABEL); }
	/* identifiers */ 
	{Identifier}		{ return symbol(sym.IDENTIFIER); }

	/* comments */
	{Comment}                      { /* ignore */ }

	/* whitespace */
	{WhiteSpace}                   { /* ignore */ }
}

<STRING> {
	\"                             { yybegin(YYINITIAL); 
								   return symbol(sym.STRING_LITERAL, 
								   string.toString()); }
	[^\n\r\"\\]+                   { string.append( yytext() ); }
	\\t                            { string.append('\t'); }
	\\n                            { string.append('\n'); }

	\\r                            { string.append('\r'); }
	\\\"                           { string.append('\"'); }
	\\                             { string.append('\\'); }
}

<CHARLITERAL> {
  [^\n\r\'\\]+\'            { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, yytext().charAt(0)); }
  
  /* escape sequences */
  "\\b"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\b');}
  "\\t"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\t');}
  "\\n"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\n');}
  "\\f"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\f');}
  "\\r"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\r');}
  "\\\""\'                       { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\"');}
  "\\'"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\'');}
  "\\\\"\'                       { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\\'); }
  \\[0-3]?{OctDigit}?{OctDigit}\' { yybegin(YYINITIAL); 
										int val = Integer.parseInt(yytext().substring(1, yylength() - 1), 8);
			                            return symbol(sym.CHARACTER_LITERAL, (char)val); }
  
  /* error cases */
  \\.                            { throw new RuntimeException("Illegal escape sequence \""+yytext()+"\""); }
  {LineTerminator}               { throw new RuntimeException("Unterminated character literal at end of line"); }
}

[^]									{ throw new Error("Illegal character <"+
										yytext()+">"); }
