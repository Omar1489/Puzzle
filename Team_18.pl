% ------------------------creating a Matrix-----------------------
grid_build(0,[]).
grid_build(Length,Result) :- 
			length(Result,Length),
			extend_List(Length,Result).
extend_List(_,[]).
extend_List(Length,[H|T]) :-
			length(H,Length),
			extend_List(Length,T).

% -----------------------Max value in a Matrix-----------------------------------------			
max_Matrix(Matrix,Max) :-
			max_Matrix_PhaseOne(Matrix,List_Max),
			max_list(List_Max,Max).
max_Matrix_PhaseOne([],[]).
max_Matrix_PhaseOne([H|T],[H1|T1]) :-
			max_list(H,H1),
			max_Matrix_PhaseOne(T,T1).
			
%-----------------generates a list of numbers according to boundaries-------------------------
numGen(First,First,[First|[]]).
numGen(First,Last,[First|T]) :-
			First<Last,
			NewFirst is First +1,
			numGen(NewFirst,Last,T).

% ---------------------------checks IF an element Exists in a Matrix---------------------------
element_exist(Element,[H|_]) :-
			member(Element,H).
element_exist(Element,[H|T]) :-
			\+member(Element,H),
			element_exist(Element,T).

% -------------------------check If all elements in a list are unique--------------------
is_Unique_list([]).
is_Unique_list([H|T]) :-
			\+member(H,T),
			is_Unique_list(T).	
		
% -------------------------check If a list consists of only one repeated element----------------------
one_element_list([H|T]) :- 
			one_element_list_helper(H,T).
one_element_list_helper(_,[]).
one_element_list_helper(H,[H|T]) :-
			one_element_list_helper(H,T).			

% --------------------------- generates grids ----------------------------------------
grid_gen(N,M) :-
			grid_build(N,M),
			grid_gen_Helper1(N,M).
grid_gen_Helper1(_,[]).
grid_gen_Helper1(N,[H|T]) :-
			numGen(1,N,M),
			grid_gen_Helper2(H,M),
			\+one_element_list(H),
			\+is_Unique_list(H),
			grid_gen_Helper1(N,T),
			distinct_rows([H|T]),
			distinct_columns([H|T]).
grid_gen_Helper2([],_).
grid_gen_Helper2([H|T],M) :-
			member(H,M),
			grid_gen_Helper2(T,M).

% --------------------------- check If G does Not contain a number X Unless all the numbers 1 .. X-1 are there------------
check_num_grid(G) :-
			max_Matrix(G,Max),
			length(G,Length),
			Length >= Max,
			check_num_grid_Helper(G,Max).
check_num_grid_Helper(_,0).
check_num_grid_Helper(G,N) :-
			N > 0,
			element_exist(N,G),
			N1 is N -1,
			check_num_grid_Helper(G,N1).
							
% ---------------------------get a certain row using Index----------------------------			
get_row([H|_],1,H).
get_row([_|T],Index,Row) :-
			Index>1,
			NewIndex is Index -1,
			get_row(T,NewIndex,Row).

% ---------------------------get certain element from a row using its Index--------------------------
get_element_row([H|_],1,H).
get_element_row([_|T],Index,R)	:-
			Index>1,
			NewIndex is Index -1,
			get_element_row(T,NewIndex,R).
			

% ----------------------------get a certain column using Index-----------------------------------
get_column([],_,[]).          	
get_column([H|T],Index,[H1|T1]):-
			get_element_row(H,Index,H1),
			get_column(T,Index,T1).
				
% -----------------------------get transpose of a Matrix-----------------------------------
transpose([],[]).
transpose(M1,M2) :-
			transpose_helper(M1,1,M2).	
transpose_helper(M1,Index,[]) :- length(M1,L) , Index>L.			
transpose_helper(M1,Index,[H|T]) :-
			length(M1,L),
			Index =< L,
			get_column(M1,Index,H),
			NewIndex is Index + 1,
			transpose_helper(M1,NewIndex,T).

%------------------------------Compare list to tail----------------------------
compare_List_Tail(_,[]).
compare_List_Tail(List,[H|T]) :-
			List\=H,
			compare_List_Tail(List,T).

% ----------------------check If all rows are distinct-----------------------------------
distinct_rows([]).
distinct_rows([H|T]) :-
			compare_List_Tail(H,T),
			distinct_rows(T).

% ----------------------check If all columns are distinct-----------------------------------
distinct_columns(Matrix) :-
			transpose(Matrix,TransMatrix),
			distinct_rows(TransMatrix).	
			
% -----------------check If No row is placed in a column with the same Index And No column is placed in a row with the same Index---------			
acceptable_distribution(M) :-
			transpose(M,M1),
			acceptable_distribution_Helper(M,M1).
acceptable_distribution_Helper([],[]).			
acceptable_distribution_Helper([H|T],[H1|T1]) :-
			H\=[],
			H1\=[],
			H\=H1,
			acceptable_distribution_Helper(T,T1).
			
% --------------check If a row is equal to another column but with different Index------------------------------
row_column_match(M) :-
			transpose(M,MT),
			acceptable_distribution_Helper(M,MT),
			row_column_match_Helper(M,MT).
row_column_match_Helper([],_).
row_column_match_Helper([H|T],MT) :-
			\+compare_List_Tail(H,MT),
			row_column_match_Helper(T,MT).	
% -------------------------check If a list has acceptable permutation----------------------------
acceptable_permutation(L,R) :-
			lists:perm(L,Perm),
			acceptable_permutation_Helper(L,Perm,R).
acceptable_permutation_Helper([],[],[]).
acceptable_permutation_Helper([H|T],[C|R],[C|T2]) :-
			H\=C,
			acceptable_permutation_Helper(T,R,T2).

% -----------------test game ----------------------------------------------------------
helsinki1(N,M):-
			grid_gen(N,M),
			check_num_grid(M),
			row_column_match(M).

helsinki(K,M):-
			setof(X,helsinki1(K,X),E),
			member(M,E).
				
				


			
			
			
			
			