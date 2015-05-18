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

% Utility Rules

neg(Goal) :- Goal,!,fail.
neg(Goal).

% Basic Rules

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

% Join Rules

% Equivalence
join_check(equivalence,equivalence,equivalence).

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

join_check(independence,independence,total).

% Forward Entailment
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

% Reverse Entailment
join_check(reverse_entailment,reverse_entailment,reverse_entailment).

join_check(negation,reverse_entailment,alternation).

join_check(reverse_entailment,negation,cover).

join_check(alternation,reverse_entailment,alternation).

join_check(reverse_entailment,alternation,independence).

join_check(cover,reverse_entailment,independence).

join_check(reverse_entailment,cover,independence).

join_check(independence,reverse_entailment,independence).

join_check(reverse_entailment,independence,independence).

% Negation

join_check(negation,negation,negation).

join_check(alternation,negation,forward_entailment).

join_check(negation,alternation,reverse_entailment).

join_check(cover,negation,reverse_entailment).

join_check(negation,cover,forward_entailment).

join_check(independence,negation,independence).

join_check(negation,independence,independence).

% Alternation

join_check(alternation,alternation,independence).

join_check(cover,alternation,reverse_entailment).

join_check(alternation,cover,forward_entailment).

join_check(independence,alternation,independence).

join_check(alternation,independence,independence).

% Cover

join_check(cover,cover,independence).

join_check(independence,cover,independence).

join_check(cover,independence,independence).

% Independence

join_check(independence,independence,total).


% Sentence Comparison
compare_sentences([],[],_,_).
compare_sentences([X|XTail],[X|YTail],Z,R) :- !,compare_sentences(XTail,YTail,Z,R).
compare_sentences([X|XTail],[Y|YTail],[Z|ZTail],[R|RTail]) :- XTail == [],
                                                    base_check(X,Y,independence),
                                                    ZTail = [],
                                                    RTail = [],
                                                    compare_sentences([],[],ZTail,RTail),!.
compare_sentences([X|XTail],[Y|YTail],[Z|ZTail],[R|RTail]) :- XTail == [],
                                                    base_check(X,Y,A),
                                                    Z = A,
                                                    R = A,
                                                    ZTail = [],
                                                    RTail = [],
                                                    compare_sentences([],[],ZTail,RTail),!.
compare_sentences([X|XTail],[Y|YTail],[Z|ZTail],[R|RTail]) :- YTail == [],
                                                    base_check(X,Y,independence),
                                                    Z = independence,
                                                    compare_sentences(XTail,[Y],ZTail,RTail),!,
                                                    % nth0(0,ZTail,ZHead),
                                                    nth0(0,RTail,RHead),
                                                    join_check(Z,RHead,R).
compare_sentences([X|XTail],[Y|YTail],[X|ZTail],[R|RTail]) :- YTail == [],
                                                    base_check(X,Y,A),
                                                    Z = A,
                                                    compare_sentences(XTail,[Y],ZTail,RTail),
                                                    % nth0(0,ZTail,ZHead),
                                                    nth0(0,RTail,RHead),
                                                    join_check(Z,RHead,R).
compare_sentences([X|XTail],[Y|YTail],[Z|ZTail],[R|RTail]) :- base_check(X,Y,independence),
                                                    Z = independence,
                                                    append([Y], YTail, YFull),
                                                    compare_sentences(XTail,YFull,ZTail,RTail),
                                                    % nth0(0,ZTail,ZHead),
                                                    nth0(0,RTail,RHead),
                                                    join_check(Z,RHead,R).
compare_sentences([X|XTail],[Y|YTail],[Z|ZTail],[R|RTail]) :- base_check(X,Y,A),
                                                    Z = A,
                                                    append([Y], YTail, YFull),
                                                    compare_sentences(XTail,YFull,ZTail,RTail),!,
                                                    % nth0(0,ZTail,ZHead),
                                                    nth0(0,RTail,RHead),
                                                    join_check(Z,RHead,R).


