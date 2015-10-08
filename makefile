
Main.class: Main.java Lexer.java parser.java

%.class: %.java
	javac -cp .:/usr/share/java/cup.jar $^

Lexer.java: pds16.lex
	jflex pds16.lex

parser.java: pds16.cup
	cup pds16.cup

clean:
	$(RM) *.class
	$(RM) parser.java Lexer.java sym.java
	$(RM) *~



#	javac -cp .:/home/ezequiel/Downloads/jflex-1.6.1/jflex-1.6.1/lib/java-cup-11a.jar $^
#	javac -cp .:/usr/share/java/cup.jar $^
