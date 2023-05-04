is_category(Y):-
    word(_,Y).

categories(L):-
    setof(Y,is_category(Y),L).
	
	

available_length(L):-
	word(X,_),
	string_length(X,R),
	L=R.
	

pick_word(W,L,C):-
	word(W,C),
	string_length(W,L).
	
	

correct_letters([X|Y],M,[X|Z]):- member(X,M), delete(X,M,M1),correct_letters(Y,M1,Z).
correct_letters([X|Y],M,Z):- \+ member(X,M), correct_letters(Y,M,Z).
correct_letters([],_,[]).
	
correct_positions([X|Y],[X|M],[X|Z]):- correct_positions(Y,M,Z).
correct_positions([X|Y],[N|M],Z):- X\=N , correct_positions(Y,M,Z).
correct_positions([],_,[]).


delete(X,[X|R],R) :- \+member(X,R).
delete(X,[X|R],S) :- member(X,R), delete(X,R,S).
delete(X,[Y|R],[Y|S]) :- delete(X,R,S).



build_kb:-
    write('Please enter a word and its category on separate lines:'),nl,
    read(X),
    (X = done ,write(""),nl,write("Done building the words database...") ; read(Y),assert(word(X,Y)),build_kb).



choose_category(R):-
	write("Choose a category: "),nl,
	read(C),
    ((is_category(C),R=C);  write("This category does not exist."),nl,choose_category(R)).



choose_length(C,L,A):-
	write("Choose a length: "),nl,
	read(X),
	((available_length(X),pick_word(W,X,C),L=X,A=W) ; write("There are no words of this length."),nl,choose_length(C,L,A)).
	



game(W,T,L):-
	write("Enter a word composed of "),write(L),write(" letters:"),nl,read(X),
	((string_length(X,P),P\=L,write("Word is not composed of "),write(L),write(" letters. Try again."),nl,write("Remaining Guesses are  "),write(T),nl,write(""),nl,game(W,T,L));
	(X=W,write("You Won!"));
	(T1 is T-1,T1=0,write("You lost!"));
	(atom_chars(W,W1),atom_chars(X,X1),correct_letters(W1,X1,Q1),correct_positions(W1,X1,Q2),T1 is T-1,
	write("Correct letters are: "),write(Q1),nl,write("Correct letters in correct positions are: "),write(Q2),nl,write("Remaining Guesses are "),write(T1),nl,write(""),nl,game(W,T1,L))).

 	
	
	
	
	
play:-
	categories(M),
    write("The available categories are: "), write(M),nl,
	choose_category(C),
	choose_length(C,L,W),
	write("Game started. You have 6 guesses."),nl,write(""),nl,
	game(W,6,L).
	
	



main:-
    write('Welcome to Pro-Wordle!'),nl,
    write('----------------------'),nl,
    build_kb,
	write(""),nl,write(""),nl,
	play.
	