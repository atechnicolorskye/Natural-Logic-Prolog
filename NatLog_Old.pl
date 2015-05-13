% Equivalence Lists
equivalence(sofa,couch).
forward_entailment(crow,bird).
reverse_entailment(european,french).
negation(human,non-human).
alternation(cat,dog).
cover(animal,non-human).

% Basic Rules

equivalence(X,Y).
forward_entailment(X,Y).
reverse_entailment(X,Y).
negation(X,Y).
alternation(X,Y).
cover(X,Y).
independence(X,Y) :- neg(equivalence(X,Y)),
                     neg(forward_entailment(X,Y)),
                     neg(reverse_entailment(X,Y)),
                     neg(negation(X,Y)),
                     neg(alternation(X,Y)),
                     neg(cover(X,Y)).

base_check(X,Y) :- equivalence(X,Y).
base_check(X,Y) :- forward_entailment(X,Y).
base_check(X,Y) :- reverse_entailment(X,Y).
base_check(X,Y) :- negation(X,Y).
base_check(X,Y) :- alternation(X,Y).
base_check(X,Y) :- cover(X,Y).
base_check(X,Y) :- independence(X,Y)

% For Join Rules with union relations, they will be approximated to independence
% Join Rules - Equivalence

join_check(X,Z,equivalence) :- equivalence(X,Y),
                    equivalence(Y,Z).

join_check(X,Z,forward_entailment) :- equivalence(X,Y),
                           forward_entailment(Y,Z).

join_check(Z,X,forward_entailment) :- forward_entailment(Z,Y),
                           equivalence(Y,X).

join_check(X,Z,reverse_entailment) :- equivalence(X,Y),
                           reverse_entailment(Y,Z).

join_check(Z,X,reverse_entailment) :- reverse_entailment(Z,Y),
                           equivalence(Y,X).

join_check(X,Z,negation) :- equivalence(X,Y),
                           negation(Y,Z).

join_check(Z,X,negation) :- negation(Z,Y),
                           equivalence(Y,X).

join_check(X,Z,alternation) :- equivalence(X,Y),
                           alternation(Y,Z).

join_check(Z,X,alternation) :- alternation(Z,Y),
                           equivalence(Y,X).

join_check(X,Z,cover) :- equivalence(X,Y),
                           cover(Y,Z).

join_check(Z,X,cover) :- cover(Z,Y),
                           equivalence(Y,X).

join_check(X,Z,independence) :- equivalence(X,Y),
                           independence(Y,Z).

join_check(Z,X,independencejoin_check) :- independence(Z,Y),
                           equivalence(Y,X).

% Join Rules - Forward Entailment
forward_entailment(X,Z) :- forward_entailment(X,Y),
                           forward_entailment(Y,Z).

independence(X,Z) :- reverse_entailment(X,Y),
                           forward_entailment(Y,Z).

independence(Z,X) :- forward_entailment(Z,Y),
                           reverse_entailment(Y,X).

cover(X,Z) :- negation(X,Y),
                           forward_entailment(Y,Z).

alternation(Z,X) :- forward_entailment(Z,Y),
                           negation(Y,X).

independence(X,Z) :- alternation(X,Y),
                           forward_entailment(Y,Z).

alternation(Z,X) :- forward_entailment(Z,Y),
                           alternation(Y,X).

cover(X,Z) :- cover(X,Y),
                           forward_entailment(Y,Z).

independence(Z,X) :- forward_entailment(Z,Y),
                           cover(Y,X).

independence(X,Z) :- independence(X,Y),
                           forward_entailment(Y,Z).

independence(Z,X) :- forward_entailment(Z,Y),
                           independence(Y,X).

% Join Rules - Reverse Entailment
reverse_entailment(X,Z) :- reverse_entailment(X,Y),
                           reverse_entailment(Y,Z).

alternation(X,Z) :- negation(X,Y),
                           reverse_entailment(Y,Z).

cover(Z,X) :- reverse_entailment(Z,Y),
                           negation(Y,X).

alternation(X,Z) :- alternation(X,Y),
                           reverse_entailment(Y,Z).

independence(Z,X) :- reverse_entailment(Z,Y),
                           alternation(Y,X).

independence(X,Z) :- cover(X,Y),
                           reverse_entailment(Y,Z).

cover(Z,X) :- reverse_entailment(Z,Y),
                           cover(Y,X).

independence(X,Z) :- independence(X,Y),
                           reverser_entailment(Y,Z).

independence(Z,X) :- reverser_entailment(Z,Y),
                           independence(Y,X).

% Join Rules - Negation

negation(X,Z) :- negation(X,Y),
                           negation(Y,Z).

forward_entailment(X,Z) :- alternation(X,Y),
                           negation(Y,Z).

reverse_entailment(Z,X) :- negation(Z,Y),
                           alternation(Y,X).

reverse_entailment(X,Z) :- cover(X,Y),
                           negation(Y,Z).

forward_entailment(Z,X) :- negation(Z,Y),
                           cover(Y,X).

independence(X,Z) :- independence(X,Y),
                           negation(Y,Z).

independence(Z,X) :- negation(Z,Y),
                           independence(Y,X).

% Join Rules - Alternation

independence(X,Z) :- alternation(X,Y),
                           alternation(Y,Z).

reverse_entailment(X,Z) :- cover(X,Y),
                           alternation(Y,Z).

forward_entailment(Z,X) :- alternation(Z,Y),
                           cover(Y,X).

independence(X,Z) :- independence(X,Y),
                           alternation(Y,Z).

independence(Z,X) :- alternation(Z,Y),
                           independence(Y,X).

% Join Rules - Cover

independence(X,Z) :- cover(X,Y),
                           cover(Y,Z).

independence(X,Z) :- independence(X,Y),
                           cover(Y,Z).

independence(Z,X) :- cover(Z,Y),
                           independence(Y,X).

% Join Rules - Independence

total(X,Z) :- independence(X,Y),
                           independence(Y,Z).
