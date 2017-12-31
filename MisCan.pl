/* MisCan.pl
* HW10
* Solution to the missionaries and cannibals problem
* Professor Scharstein cs313 - Programming Languages
*/
:- debug.
:- use_module(library(lists)).

/*************************** Test for legality *************************/
% definitions of the permissable cannibal/missionary sets.
legal(3,3,0,0).
legal(2,2,1,1).
legal(1,1,2,2).
legal(3,2,0,1).
legal(3,1,0,2).
legal(3,0,0,3).

legal(0,0,3,3).
legal(1,1,2,2).
legal(2,2,1,1).
legal(0,1,3,2).
legal(0,2,3,1).
legal(0,3,3,0).


/*************************** Print functions *************************/
% Used code from goat.pl as a base

printAll :-
	solve(Result),
	nl,
	printList(Result),
	fail.

printList([]).
printList([[H|H1]|T]) :-
	printList(T),
	write(H1),
	write(H),
	nl.

/*************************** Possible Moves *************************/

% 1 can 1 man left -> right
makeMove([ML,CL,MR,CR,left], [ML1,CL1,MR1,CR1,right]) :-
	CR1 is CR+1,
	CL1 is CL-1,
	MR1 is MR+1,
	ML1 is ML-1,
	legal(ML1,CL1,MR1,CR1).

% 2 missionary  left -> right
makeMove([ML,CL,MR,CR,left], [ML1,CL1,MR1,CR1,right]) :-
	MR1 is MR+2,
	ML1 is ML-2,
	CR1 = CR,
	CL1 = CL,
	legal(ML1,CL1,MR1,CR1).

% 2 can left -> right
makeMove([ML,CL,MR,CR,left], [ML1,CL1,MR1,CR1,right]) :-
	CR1 is CR+2,
	CL1 is CL-2,
	ML1 = ML,
	MR1 = MR,
	legal(ML1,CL1,MR1,CR1).

% 1 missionary  left -> right
makeMove([ML,CL,MR,CR,left], [ML1,CL1,MR1,CR1,right]) :-
	MR1 is MR+1,
	ML1 is ML-1,
	CR1 = CR,
	CL1 = CL,
	legal(ML1,CL1,MR1,CR1).

% 1 can left -> right
makeMove([ML,CL,MR,CR,left], [ML1,CL1,MR1,CR1,right]) :-
	CR1 is CR+1,
	CL1 is CL-1,
	MR1 = MR,
	ML1 = ML,
	legal(ML1,CL1,MR1,CR1).

% 1 can 1 man right -> left
makeMove([ML,CL,MR,CR,right], [ML1,CL1,MR1,CR1,left]) :-
	CR1 is CR-1,
	CL1 is CL+1,
	MR1 is MR-1,
	ML1 is ML+1,
	legal(ML1,CL1,MR1,CR1).

% 2 missionary  right -> left
makeMove([ML,CL,MR,CR,right], [ML1,CL1,MR1,CR1,left]) :-
	MR1 is MR-2,
	ML1 is ML+2,
	CR1 = CR,
	CL1 = CL,
	legal(ML1,CL1,MR1,CR1).

% 2 can right -> left
makeMove([ML,CL,MR,CR,right], [ML1,CL1,MR1,CR1,left]) :-
	CR1 is CR-2,
	CL1 is CL+2,
	MR1 = MR,
	ML1 = ML,
	legal(ML1,CL1,MR1,CR1).

% 1 missionary right -> left
makeMove([ML,CL,MR,CR,right], [ML1,CL1,MR1,CR1,left]) :-
	MR1 is MR-1,
	ML1 is ML+1,
	CR1 = CR,
	CL1 = CL,
	legal(ML1,CL1,MR1,CR1).

% 1 can right -> left
makeMove([ML,CL,MR,CR,right], [ML1,CL1,MR1,CR1,left]) :-
	CR1 is CR-1,
	CL1 is CL+1,
	MR1 = MR,
	ML1 = ML,
	legal(ML1,CL1,MR1,CR1).

/*************************** Solve Functions *************************/

/* this calls the main search routine solve/5 */
solve(Result) :-
	/* initial values (makes it easier to read): */
	CurrentState = [3,3,0,0,left], /* States the current state */
	Goal = [0,0,3,3,right],        /* End state */
	Moves = [CurrentState],       /* moves made so far */
	Prev = [],  /* states been in so far */
	solve(CurrentState, Goal, Moves, Prev, Result).

/* Detects when solve is done, i.e. when CurrentState matches Goal. For
some reason I could not get the reverse(Prev, result) to work as it did
in goat.pl. Instead I just called printList on Prev and then reversed the
output in my printList function. */
solve([0,0,3,3, right], [0,0,3,3, right], _, Prev, _):-
	printList(Prev).

/*Solve/5 function. I used many of the ideas for solving this problem that
were discussed in class. */
solve(CurrentState, Goal, Moves, Prev, Result) :-
     makeMove(CurrentState, M),
     not(member(M, Moves)),
     solve(M, Goal, [M| Moves],
		[[M, CurrentState] | Prev], Result).
