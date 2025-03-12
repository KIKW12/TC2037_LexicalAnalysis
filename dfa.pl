% DFA states
% a: Initial state: No 1 seen yet
% b: At least one 1 seen
% c: At least one 1 seen and one 0 of potential "002" seen
% d: At least one 1 seen and "00" of potential "002" seen
% e: At least one 1 seen and "002" seen (accepting state)

% Initial state
initial_state(a).

% Accepting states
accepting_state(e).

% Transition function for the DFA
transition(a, 0, a).  % Stay in initial state on 0
transition(a, 1, b).  % See 1, move to state b

transition(b, 0, c).  % First 0 of potential "002"
transition(b, 1, b).  % Another 1
transition(b, 2, b).  % 2 is allowed since we've seen a 1

transition(c, 0, d).  % Second 0 of potential "002"
transition(c, 1, b).  % Lost potential "002"
transition(c, 2, b).  % Lost potential "002"

transition(d, 0, c).  % New potential first 0 of "002"
transition(d, 1, b).  % Lost potential "002"
transition(d, 2, e).  % Matched "002", accepting state

transition(e, 0, c).  % First 0 of potential new "002"
transition(e, 1, b).  % Lost ending
transition(e, 2, b).  % Lost ending

% accept/1 checks if a string is accepted by the DFA
accept(String) :-
    initial_state(InitialState),
    traverse(InitialState, String).

% traverse/2 processes the string symbol by symbol through the DFA
traverse(CurrentState, []) :-
    accepting_state(CurrentState).  % Accept if we're in an accepting state and have processed the whole string
traverse(CurrentState, [Symbol|Rest]) :-
    transition(CurrentState, Symbol, NextState),
    traverse(NextState, Rest).

% Test cases with expected results
test_case([1,0,0,2], true, 'Has 1 before 2 and ends with 002').
test_case([0,0,2], false, 'Missing 1 before 2').
test_case([1,0,2,2], false, 'Doesn\'t end with 002').
test_case([1,0,2,0,0,2], true, 'Has 1 before 2 and ends with 002').
test_case([0,1,2,0,0,2], true, 'Has 1 before 2 and ends with 002').
test_case([0,0,1,2,0,0,2], true, 'Has 1 before 2 and ends with 002').
test_case([0,1,0,0,2], true, 'Has 1 and ends with 002 (no 2 before end)').
test_case([1,1,1,0,0,2], true, 'Multiple 1s and ends with 002').
test_case([1,0,0,1,0,0,2], true, 'Has 1 and ends with 002').
test_case([2,0,0,2], false, 'No 1 before first 2').
test_case([1,0,0], false, 'Doesn\'t end with 002').
test_case([0,0,0,1,0,0,2], true, 'Multiple leading zeros, 1, then 002').
test_case([1,0,0,0,0,0,0,0,0,2], true, 'Many zeros between 1 and 2').
test_case([1,2,1,2,1,2,0,0,2], true, 'Alternating 1,2 pattern before 002').
test_case([], false, 'Empty string').
test_case([1], false, 'Just 1, too short').
test_case([0,0,2,0,0,2], false, 'Missing required 1').
test_case([0,0,0,2], false, 'Only zeros and 2, no 1').
test_case([1,0,0,2,3], false, 'Invalid character 3').
test_case([1,0,3,0,0,2], false, 'Invalid character in middle').
test_case([1,0,0,2,0,0,2], true, '002 appears twice, ending is correct').
test_case([1,2,0,0,2], true, '2 after 1 is allowed').
test_case([0,1,0,2,0,0,2], true, '2 in middle is allowed').
test_case([1,0,0,2,0], false, 'Doesn\'t end with 002').
test_case([0,0,0,1,0,0], false, 'Missing final 2').
test_case([1,0,2], false, 'Missing a 0 in the final 002').
test_case([3,1,0,0,2], false, 'Invalid character at start').
test_case([1,0,0,2,0,0], false, 'Starts correctly but ends with 00').
test_case([0,0,0,0,1,2,2,2,0,0,2], true, 'Complex valid pattern').

% Automatically run tests when code is loaded
:- 
    format('~nRunning DFA tests:~n~n'),
    format('~w~t~20|~w~t~30|~w~n', ['Input', 'Expected', 'Result']),
    format('~`-t~50|~n'),
    forall(
        test_case(Input, Expected, Description),
        (
            (accept(Input) -> Actual = true ; Actual = false),
            (Expected == Actual -> Result = 'PASS' ; Result = 'FAIL'),
            % Convert input to string representation
            with_output_to(string(InputStr), write(Input)),
            % Print the result
            format('~w~t~20|~w~t~30|~w ~w~n', 
                   [InputStr, Expected, Result, Description])
        )
    ),
    format('~nTests completed.~n').