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

join_check(equivalence,Z,equivalence).

join_check(equivalence,forward_entailment,forward_entailment).

join_check(forward_entailment,equivalence,forward_entailment).

join_check(equivalence,reverse_entailment,reverse_entailment).

join_check(reverse_entailment,equivalence,reverse_entailment).

join_check(equivalence,negation,negation).

join_check(negation,equivalence,negation).

join_check(equivalence,alternation,alternation).

join_check(alternation,equivalence,alternation).

join_check(equivalence,cover,cover).

join_check(cover,equivalence,cover).

join_check(equivalence,independence,independence).

join_check(independence,equivalence,independence).

% Join Rules - Forward Entailment
join_check(forward_entailment,forward_entailment,forward_entailment).

join_check(reverse_entailment,forward_entailment,independence).

join_check(forward_entailment,reverse_entailment,independence).

join_check(negation,forward_entailment,cover).

join_check(forward_entailment,negation,alternation).

join_check(alternation,forward_entailment,independence).

join_check(forward_entailment,alternation,alternation).

join_check(cover,forward_entailment,cover).

join_check(forward_entailment,cover,independence).

join_check(independence,forward_entailment,independence).

join_check(forward_entailment,independence,independence).

% Join Rules - Reverse Entailment
join_check(reverse_entailment,reverse_entailment,reverse_entailment).

join_check(negation,reverse_entailment,alternation).

join_check(reverse_entailment,negation,cover).

join_check(alternation,reverse_entailment,alternation).

join_check(reverse_entailment,alternation,independence).

join_check(cover,reverse_entailment,independence).

join_check(reverse_entailment,cover,independence).

join_check(independence,reverse_entailment,independence).

join_check(reverse_entailment,independence,independence).

% Join Rules - Negation

join_check(negation,negation,negation).

join_check(alternation,negation,forward_entailment).

join_check(negation,alternation,reverse_entailment).

join_check(cover,negation,reverse_entailment).

join_check(negation,cover,forward_entailment).

join_check(independence,negation,independence).

join_check(negation,independence,independence).

% Join Rules - Alternation

join_check(alternation,alternation,independence).

join_check(cover,alternation,reverse_entailment).

join_check(alternation,cover,forward_entailment).

join_check(independence,alternation,independence).

join_check(alternation,independence,independence).

% Join Rules - Cover

join_check(cover,cover,independence).

join_check(independence,cover,independence).

join_check(cover,independence,independence).

% Join Rules - Independence

join_check(independence,independence,total).
