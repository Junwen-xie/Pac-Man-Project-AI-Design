% This Project is UNIMELB Project2 for Declarative Programming
% Project Name : Fillin Puzzles
% Author ： Junwen Xie
% Student ID : 792715
% Introduction :...

:- ensure_loaded(library(clpfd)).
:- use_module(library(lists)).

% ###########################   Important   ###################################
% These following read File functions is Supported From UNIMELB Source
% write solve_puzzle function is the main purpose of this Project
% please Jump to slove_puzzle function to 
% ########################### Supported Source ################################

main(PuzzleFile, WordlistFile, SolutionFile) :-
	read_file(PuzzleFile, Puzzle),
	read_file(WordlistFile, Wordlist),
	valid_puzzle(Puzzle),
  transpose(Wordlist,Matrix),
	solve_puzzle(Puzzle, Wordlist, Solved),
	print_puzzle(SolutionFile, Solved).

read_file(Filename, Content) :-
	open(Filename, read, Stream),
	read_lines(Stream, Content),
	close(Stream).

read_lines(Stream, Content) :-
	read_line(Stream, Line, Last),
	(   Last = true
	->  (   Line = []
	    ->  Content = []
	    ;   Content = [Line]
	    )
	;  Content = [Line|Content1],
	    read_lines(Stream, Content1)
	).

read_line(Stream, Line, Last) :-
	get_char(Stream, Char),
	(   Char = end_of_file
	->  Line = [],
	    Last = true
	; Char = '\n'
	->  Line = [],
	    Last = false
	;   Line = [Char|Line1],
	    read_line(Stream, Line1, Last)
	).

print_puzzle(SolutionFile, Puzzle) :-
	open(SolutionFile, write, Stream),
	maplist(print_row(Stream), Puzzle),
	close(Stream).

print_row(Stream, Row) :-
	maplist(put_puzzle_char(Stream), Row),
	nl(Stream).

put_puzzle_char(Stream, Char) :-
	(   var(Char)
	->  put_char(Stream, '_')
	;   put_char(Stream, Char)
	).

valid_puzzle([]).
valid_puzzle([Row|Rows]) :-
	maplist(samelength(Row), Rows).


samelength([], []).
samelength([_|L1], [_|L2]) :-
	same_length(L1, L2).

% ###############################################################
% ######################  Problem Solving  ######################

solve_puzzle(Puzzle, Wordlist, Solved).

      



find_ss(PuzzleFile,WordlistFile,I,Rest):-      
        read_file(PuzzleFile,Puzzle),       
        read_file(WordlistFile,Wordlist),       
        make_fill(Puzzle,Puzzle_Solved),
        words_fillter(Puzzle_Solved,Wordlist,D,Word_Sloved),
        find_min(Puzzle_Solved,Word_Sloved,999,Slot,Sub,Result1,Result2),
        nth0(I,Word_Sloved,Result2,Rest).

       


test(PuzzleFile,WordlistFile,Puzzle_Solved,Word_Sloved):-
        read_file(PuzzleFile,Puzzle),       
        read_file(WordlistFile,Wordlist),       
        make_fill(Puzzle,Puzzle_Solved),
        words_fillter(Puzzle_Solved,Wordlist,D,Word_Sloved),
        print_ma(Word_Sloved).


print_ma(Matrix) :- 
    maplist(write,Matrix).


find_min([],[],Size,Slot,Wordlist,Result1,Result2) :- Slot=Result1,Wordlist=Result2. 
find_min([X|Xs],[Y|Ys],Size,Slot,Wordlist,Result1,Result2):-
         length(Y,S),
        ( compare(<,S,Size) ->    	       	
        	find_min(Xs,Ys,S,X,Y,Result1,Result2)
        	;
        	find_min(Xs,Ys,Size,Slot,Wordlist,Result1,Result2)
        	).

%#####################################################################
%######################################### WORDS FILLTER 
%######### hou xian ji 
words_fillter([],Wordlist,Dir,Result) :- Dir = Result.
words_fillter([X|Xs],Wordlist,Dir,Result):-
       choose_words_sameLength(X,Wordlist,V1,Filled),
       append(Dir,[Filled],Dir1),
       words_fillter(Xs,Wordlist,Dir1,Result).

choose_words_sameLength(X,[],Wordlist,Result):- Wordlist = Result .
choose_words_sameLength(X,[Y|Ys],Wordlist,Result):-
                         
     ( samelength(X,Y) , choose_char(X,Y)->
     	append(Wordlist,[Y],Wordlist1),
     	choose_words_sameLength(X,Ys,Wordlist1,Result)
        ;
        choose_words_sameLength(X,Ys,Wordlist,Result)
     	).

choose_char([],[]).
choose_char([X|Xs],[Y|Ys]):-
         ( var(X) ->
         	choose_char(Xs,Ys)
         	;
         	X = Y,
         	choose_char(Xs,Ys)
         	).
         

%##################################################################
%################################
make_fill(Puzzle,Solved):-
   build_puzzle(Puzzle,[],X),
   build_table(Puzzle,X,Matrix0),
   pick_solt_table(Matrix0,A,R0),
   transpose(Matrix0,Matrix1),
   pick_solt_table(Matrix1,B,R1),
   append(R0,R1,R3),
   fillter_list(R3,Element,L,Solved).


fillter_list([],Element,Result,Result2) :- Result = Result2.
fillter_list([X|Xs],Element,Result,Result2):-
         length(X,Size),
         ( Size =:= 1 ->
         	fillter_list(Xs,Element,Result,Result2)
         	;
         	append(Result,[X],Result1),
         	fillter_list(Xs,Element,Result1,Result2)
         	).

       
%##############################################################################
build_table([],[],[]).
build_table([X|Xs],[Y|Ys],[First1|FilledP]):-
      build_list(X,Y,First1),
      build_table(Xs,Ys,FilledP).

% make a new List of List Puzzle bind with Variables.
build_puzzle([],RestP,Result):-RestP=Result.
build_puzzle([First|Rest],RestP,Result) :-
    samelength(First,FirstP),
    build_puzzle(Rest,[FirstP|RestP],Result).

build_list(List1,List2,Result):-build_list(List1,List2,[],Result).

build_list([],[],Result,Result2):-Result2=Result.

build_list([X|Xs],[Y|Ys],Result,Result2):-
      ( X == '_' ->
      	append(Result,[Y],Result1),
      	build_list(Xs,Ys,Result1,Result2)
      	;
      	X = Y,
      	append(Result,[Y],Result1),
      	build_list(Xs,Ys,Result1,Result2)
      	).
%%#############################################################################

%%############### Pick up Words slot from Maked new Puzzle#####################

pick_solt([],Hand_solt,Hand_List,Result):-
           (
           	 Hand_solt = [] -> 
           	 Hand_List = Result
           	 ;
           	 append(Hand_List,[Hand_solt],Hand_List1),
             Hand_List1=Result
           	).
          
pick_solt([X|Xs],Hand_solt,Hand_List,Result):-
           (
           	 nonvar(X),X='#' ->
           	     (Hand_solt = [] ->

           	     	pick_solt(Xs,[],Hand_List,Result)
           	     	;
          
            	   append(Hand_List,[Hand_solt],Hand_List1),
            	   pick_solt(Xs,[],Hand_List1,Result)
           	   )
           	;          	 
           	append(Hand_solt,[X],Hand_solt1),
           	pick_solt(Xs,Hand_solt1,Hand_List,Result)
          	).

pick_solt_table([],Result,Result1) :- Result =Result1 .
pick_solt_table([X|Xs],Result,Result1):-        
          pick_solt(X,A,L,R),       
          append(Result,R,Pass1),         
          pick_solt_table(Xs,Pass1,Result1).
%%#############################################################################






