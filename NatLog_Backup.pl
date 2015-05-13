% Backup
% compare_sentences([],[],[]).
% compare_sentences([X|XTail],[X|YTail],Z) :- !,compare_sentences(XTail,YTail,Z).
% compare_sentences([X|XTail],[Y|YTail],[X|Z]) :- XTail == [],
%                                                 Z = [],
%                                                 compare_sentences([],[],Z),!.
% compare_sentences([X|XTail],[Y|YTail],[X|Z]) :- YTail == [],
%                                                 compare_sentences(XTail,[Y],Z).
% compare_sentences([X|XTail],[Y|YTail],[X|Z]) :- compare_sentences(XTail,[Y,YTail],Z).

% Equivalence Lists
equivalence(escape,escaped).
forward_entailment(crow,bird).
reverse_entailment(european,french).
negation(human,non-human).
alternation(cat,dog).
cover(animal,non-human).

% Basic Rules

neg(Goal) :- Goal,!,fail.
neg(Goal).

base_check(X,Y,equivalence) :- equivalence(X,Y); equivalence(Y,X).
base_check(X,Y,forward_entailment) :- forward_entailment(X,Y); forward_entailment(Y,X).
base_check(X,Y,reverse_entailment) :- reverse_entailment(X,Y); reverse_entailment(Y,X).
base_check(X,Y,negation) :- negation(X,Y); negation(Y,X).
base_check(X,Y,alternation) :- alternation(X,Y); alternation(Y,X).
base_check(X,Y,cover) :- cover(X,Y); cover(Y,X).
base_check(X,Y,independence) :- neg(base_check(X,Y,equivalence)),
                                neg(base_check(X,Y,forward_entailment)),
                                neg(base_check(X,Y,reverse_entailment)),
                                neg(base_check(X,Y,negation)),
                                neg(base_check(X,Y,alternation)),
                                neg(base_check(X,Y,cover)).

% Sentence Comparison
compare_sentences([],[],_).
compare_sentences([X|XTail],[X|YTail],Z) :- !,compare_sentences(XTail,YTail,Z).
compare_sentences([X|XTail],[Y|YTail],[Z|ZTail]) :- XTail == [],
                                                    base_check(X,Y,independence),
                                                    ZTail = [],
                                                    compare_sentences([],[],ZTail),!.
compare_sentences([X|XTail],[Y|YTail],[Z|ZTail]) :- XTail == [],
                                                    base_check(X,Y,A),
                                                    Z = A,
                                                    ZTail = [],
                                                    compare_sentences([],[],ZTail),!.
compare_sentences([X|XTail],[Y|YTail],[Z|ZTail]) :- YTail == [],
                                                    base_check(X,Y,independence),
                                                    Z = X,
                                                    compare_sentences(XTail,[Y],ZTail),!,
                                                    % join_check(Z,ZTail,R)
                                                    % Z = R
                                                    % ZTail = [].
compare_sentences([X|XTail],[Y|YTail],[X|ZTail]) :- YTail == [],
                                                    base_check(X,Y,A),
                                                    Z = A,
                                                    compare_sentences(XTail,[Y],ZTail).
compare_sentences([X|XTail],[Y|YTail],[Z|ZTail]) :- base_check(X,Y,independence),
                                                    Z = X,
                                                    compare_sentences(XTail,[Y,YTail],ZTail).
compare_sentences([X|XTail],[Y|YTail],[Z|ZTail]) :- base_check(X,Y,A),
                                                    Z = A,
                                                    compare_sentences(XTail,[Y,YTail],ZTail),!.


