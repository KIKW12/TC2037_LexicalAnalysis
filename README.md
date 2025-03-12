# Evidence 1: Implementation of Lexical Analysis 
Juan Enrique Ayala Zapata -- A01711235

## Description
For this first evidence, I will develop a lexical analyzer capable of recognizing a specific language. The chosen language must have all the possible combinations of (012) and must follow the next rules:
1. Must have 1 before 2 always.
2. Must end in 002.

To be able to solve this problem, the solution presented is based on a formal language theory and automata theory, specifically using a Deterministic Finite Automaton (DFA), that according to standford U [1]mathematical model used for determing whether a string is contained within some language.

As defined by Hopcropt et al. [2], a DFA is a 5-tuple (Q, Σ, δ, q₀, F), where:
- Q is the finite set of states.
- Σ is the finite set of input symbols (also known as the alphabet).
- δ is the transition function mapping Q x Σ → Q
- q₀ is the initial state (q₀ ∈ Q ).
- F is the set of accepting/final states (F ⊆ Q).

For our specific DFA:
- Q = {a, b, c, d, e}
- Σ = {0,1,2}
- δ = transition function defined by edge/3 predicates.
- q₀ = a
- F = {e}

According to the Myhill-Nerode theorem [3], it stablishes that for any regular language that exist, there is a unique minimal DFA that is able to recognize it.

Based on the Kleene theorem [4], a regular language can be equivanlently represent by:
1. Deterministic Finite Automaton (DFA).
2. Non-Deterministic Finit Automaton (NFA).
3. Regular Expressions.

So based on what we previously said, our dual representation for this Lexical Analysis (DFA and Regular Expression) demostrates the equivalency shown at the Kleene theorem.

## Design
Based on the theory we analysed previously, we will build 2 different approaches fulfiling the Kleene theorem: 
### 1. Deterministif Finite Automaton (DFA)
(Pasar AUTOMATON DE CUADERNO A IMAGEN)
 
State Transition Table

| Starting State | Input | Final State |
| -------------- | ------| ----------- |
| a              | 0     | a           |
| a              | 1     | b           |
| b              | 0     | c           |
| b              | 1     | b           |
| b              | 2     | b           |
| c              | 0     | d           |
| c              | 1     | b           |
| c              | 2     | b           |
| d              | 0     | c           |
| d              | 1     | b           |
| d              | 2     | e           |
| e              | 0     | c           |
| e              | 1     | b           |
| e              | 2     | b           |

### 2. Regular Expression (regex)
Keeping on the Kleene theorem, we must now build a regular expression, equivalent to this DFA. 
```
^0*1(0|1|2)*002$
```
Explaining this Regular Expression:
1. You can begin the sentence with any number of '0' (even no '0').
2. Must contain a 1 the initial `0's`.
3. After the '1', can be any combination of '0', '1' or '2'.
4. The sentence must finish in '002'.

Now, we can say that we are complying with the Kleene Theorem.

## Implementation
After we have designed our DFA, we must translate it now to Prolog for propper testing and validation. We begin implementing the relations betweem states using the following format:
```
transition(current_state, symbol, next_state).
```

For instance, in our DFA, if we are in state 'a' and we read the symbol '1', we transition to state 'b'. Following the format specified above, this can be represented as:
```
transition(a, 1, b).
```

Once we have stablished all the transitions, we must inform Prolog which states cases are our accepting states. We do that by using the accepting_state predicate:
```
accepting_state(e).
```
This indicates that state 'e' is an accefting state in the DFA.

We also need to define our initial state, using the intial_state predicate:
```
initial_state(a).
```

To verify if a string is accepted by the automaton, we must implement a recursive traversal fucntion called dfa_traverse. We use the 'Head' type recurssion to parse the string from the beggining to end until we reach the base case, an empty string and an accepting state.

Fistly, we establish the base case:
```
traverse(CurrentState, []) :-
    accepting_state(CurrentState).
```
This means that if we have processed the entire string (and we end having an empty list) and ended in an accepting state, this means that the string is accepted.

For the recursive case, we process one symbol at a time:
```
traverse(CurrentState, [Symbol|Rest]) :-
    transition(CurrentState, Symbol, NextState),
    traverse(NextState, Rest).
```
Here, based on our transitions, we are changing to the next state based on the read symbol, then recursively calling 'traverse' with the remaining symbols and the current state.

Finally, we must create a public rule accept to initiate the traversal from our initial state:
```
accept(String) :-
    initial_state(InitialState),
    traverse(InitialState, String).
```

The time complexity of this DFA Algorithm ist O(n), where 'n' is the lenght of the input string. Because we are processing each symbol only one time, we are performing constant-type operations (or state transitions) at each step. 

The spatial complexity is O(n) due to the recursive call stack that could grow to the lenght of the input string.

## Testing
For testing this automaton, you only need to run the 'dfa.pl' file, and it will automatically begin a series of tests for this Regular Language. 
For running this in Prolog:
1. Clone the repo:
```
https://github.com/KIKW12/TC2037_LexicalAnalysis.git
```

2. Execute the command
```
swipl dfa.pl
```

Optioanl: If you want to add other strings to validate with this parser, follow this example to use your own string:
```
accept([1,2,0,0,2]).
```

Now, for testing the RegEx, you only have to execute the 'regex.py' file, and it will automatically begin a series of tests for this Regular Language.
For running this in Python:
1. Clone the repo:
```
https://github.com/KIKW12/TC2037_LexicalAnalysis.git
```

2. Execute the command:
```
python3 regex.py
```
Alternatively, if this command doesn't work run this instead
```
python regex.py
```

Optioanl: If you want to add other strings to validate with this parser, follow this example to use your own string:
```
12002
```

## Conclusions
In this fist evidence, we successfully designed, developed and tested 2 different approaches for a specific Regular Langauge: 'All possible combinations of 012, that all 2's must be preceded by 1, and the sentence must end in 002'.

This approach showed the practical implementation of theorical concepts of automata theory and regula languages. We implemented 2 different solutions proving the Kleene theorem, that the implementation of a DFA and a RegEx are equivalents for a Regular Language.

## References
[1] “Finite Automata Part One.” Accessed: Mar. 12, 2025. [Online]. 
    Available: https://web.stanford.edu/class/archive/cs/cs103/cs103.1142/lectures/12/Small12.pdf
    
‌
[2] J. E. Hopcroft, R. Motwani, and J. D. Ullman, "Introduction to Automata Theory, 
    Languages, and Computation," 3rd ed. Boston, MA: Addison-Wesley, 2006.
 
[3] J. Myhill and A. Nerode, "Finite automata and the representation of events," 
    Wright Air Development Center, Wright-Patterson Air Force Base, OH, Rep. WADC TR, 
    pp. 57-624, 1958.

[4] S. C. Kleene, "Representation of events in nerve nets and finite automata," 
    in Automata Studies, C. E. Shannon and J. McCarthy, Eds. Princeton, NJ: 
    Princeton University Press, 1956, pp. 3-41.
