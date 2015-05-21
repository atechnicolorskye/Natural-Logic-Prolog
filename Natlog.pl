% Backup
% compare_sentences([],[],[]).
% compare_sentences([X|XTail],[X|YTail],Z) :- !,compare_sentences(XTail,YTail,Z).
% compare_sentences([X|XTail],[Y|YTail],[X|Z]) :- XTail == [],
%                                                 Z = [],
%                                                 compare_sentences([],[],Z),!.
% compare_sentences([X|XTail],[Y|YTail],[X|Z]) :- YTail == [],
%                                                 compare_sentences(XTail,[Y],Z).
% compare_sentences([X|XTail],[Y|YTail],[X|Z]) :- compare_sentences(XTail,[Y,YTail],Z).

% Lists
equivalence(escape,escaped,0.5).
forward_entailment(crow,bird,0.5).
reverse_entailment(european,french,0.5).
negation(human,non-human,0.5).
alternation(cat,dog,0.5).
cover(animal,non-human,0.5).

equivalence(X,X,0.5).


forward_entailment(dance,move,0.5).
% forward_entailment(jeans,pants,0.5).

word(refused, alternation, 0.5).
word(to, equivalence, 0.5).
word(managed, equivalence, 5).
word(X, equivalence, 0.5).

% Utility Rules

neg(Goal) :- Goal,!,fail.
neg(Goal).

% Basic Rules

base_check(X,Y,equivalence,P) :- equivalence(X,Y,P); equivalence(Y,X,P).
base_check(X,Y,forward_entailment,P) :- forward_entailment(X,Y,P); reverse_entailment(Y,X,P).
base_check(X,Y,reverse_entailment,P) :- reverse_entailment(X,Y,P); forward_entailment(Y,X,P).
base_check(X,Y,negation,P) :- negation(X,Y,P); negation(Y,X,P).
base_check(X,Y,alternation,P) :- alternation(X,Y,P); alternation(Y,X,P).
base_check(X,Y,cover,P) :- cover(X,Y,P); cover(Y,X,P).
base_check(X,Y,independence,0.5).

%                            :- neg(base_check(X,Y,equivalence)),
%                               neg(base_check(X,Y,forward_entailment)),
%                               neg(base_check(X,Y,reverse_entailment)),
%                               neg(base_check(X,Y,negation)),
%                               neg(base_check(X,Y,alternation)),
%                               neg(base_check(X,Y,cover)).

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
compare_sentences([],_,_,_,_,_,_,_).
compare_sentences([X|XTail],[X|YTail],Z,P,Del,Ins,Sub,Mat) :- !,compare_sentences(XTail,YTail,Z,P,Del,Ins,Sub,Mat_),
                                                              append([X],Mat_,Mat).
compare_sentences([X|XTail],[Y|YTail],Z,P,Del,Ins,Sub,Mat) :-
                                            XTail == [],
                                            YTail == [],
                                            compare_word_sentence(X,[Y],Z_,P_,Del,Ins,Sub,Mat),!,
                                            (Z_ == []
                                             -> word(X,ZDel,PDel),
                                                word(Y,ZIns,PIns),
                                                join_check(ZDel,ZIns,Z),
                                                P is PDel * PIns
                                             ;  Z = Z_, P = P_
                                            ),
                                            compare_sentences([],[],Z,P,Del,Ins,Sub,Mat).

compare_sentences([X|XTail],[Y|YTail],Z,P,Del,Ins,Sub,Mat) :-
                                            XTail == [],
                                            append([Y], YTail, YFull),
                                            compare_word_sentence(X,YFull,Z_,P_,Del,Ins,Sub,Mat),!,
                                            compare_insert(Ins,ZIns,PIns),
                                            (Del == [X]
                                             -> word(X,ZDel,PDel),
                                                join_check(ZDel,ZIns,Z),
                                                P is PDel * PIns
                                             ;  join_check(Z_,ZIns,Z),
                                                P is P_ * PIns
                                            ),
                                            compare_sentences([],YTail,Z,P,Del,Ins,Sub,Mat).


compare_sentences([X|XTail],[Y|YTail],Z,P,Del,Ins,Sub,Mat) :-
                                            append([Y], YTail, YFull),
                                            compare_word_sentence(X,YFull,Z_,P_,Del_,Ins_,Sub_,Mat_),!,
                                            (Del_ == [X]
                                             -> compare_sentences(XTail,YFull,ZTail,PTail,DelTail,InsTail,SubTail,MatTail),
                                                word(X,ZDel,PDel),
                                                join_check(ZDel,ZTail,Z),
                                                P is PDel * PTail,
                                                Ins = InsTail
                                             ;  subtract(YFull,Ins_,YTail___),
                                                subtract(YTail___,Sub_,YTail__),
                                                subtract(YTail__,Mat_,YTail_),
                                                compare_sentences(XTail,YTail_,ZTail,PTail,DelTail,InsTail,SubTail,MatTail),
                                                compare_insert(Ins_,ZIns,PIns),
                                                join_check(ZIns,ZTail,ZEnd),
                                                join_check(Z_,ZEnd,Z),
                                                P is P_ * PIns * PTail,
                                                append(Ins_,InsTail,Ins)
                                            ),
                                            append(Del_,DelTail,Del),
                                            append(Mat_,MatTail,Mat),
                                            append(Sub_,SubTail,Sub).


compare_word_sentence(X,[],_,_,_,_,_,_).
compare_word_sentence(X,[Y|YTail],Z,P,Del,Ins,Sub,Match) :-
                                             YTail = [],
                                             base_check(X,Y,A,P),!,
                                             ( A == independence
                                              -> Z = [], Del = [X], Ins = [Y], Sub = [], Match = []
                                              ; (A \= equivalence
                                                -> Sub = [Y], Match = []
                                                ;  Sub = [], Match = [Y]
                                                ),
                                                Z = A, Del = [], Ins = []
                                             ),
                                             compare_word_sentence(X,YTail,Z,P,Del,Ins,Sub,Match).

compare_word_sentence(X,[Y|YTail],Z,P,Del,Ins,Sub,Match) :-
                                            base_check(X,Y,A,P_),!,
                                            ( A == independence
                                             -> compare_word_sentence(X,YTail,Z,PTail,Del,Ins_,Sub_,Match_),
                                                P is 1 * PTail,
                                                append([Y],Ins_,Ins),
                                                append([],Sub_,Sub),
                                                append([],Match_,Match)
                                             ; (A \= equivalence
                                                -> Sub = [Y], Match = []
                                                ;  Sub = [], Match = [Y]
                                                ),
                                                Z = A, P is P_, PTail=1, Del = [], Ins = [],
                                                compare_word_sentence(X,[],Z,PTail,Del,Ins,Sub,Match)
                                            ).


compare_insert([],equivalence,1).
compare_insert([],_,_) :- compare_insert([],equivalence,1).
compare_insert([Ins|InsTail],R,P) :-    word(Ins,Z,P_),
                                        compare_insert(InsTail,RTail,PTail),!,
                                        join_check(Z,RTail,R),
                                        P is P_ * PTail.


% Unused Rules

% compare_sentences([X|XTail],[Y|YTail],[Z|ZTail],[R|RTail],[Del|DelTail],[Ins|InsTail]) :-
%                                             XTail == [],
%                                             append([Y], YTail, YFull),
%                                             compare_word_sentence(X,YFull,Z_,Del_,Ins_),
%                                             Del_ = [],
%                                             Del = Del_,
%                                             Ins = Ins_,!,
%                                             compare_insert(Ins,Z__,R_),
%                                             nth0(0,R_,RHead),
%                                             Z = RHead,
%                                             R = RHead,
%                                             compare_sentences([],_,Z,R,[],Ins).

% compare_sentences([X|XTail],[Y|YTail],[Z|ZTail],[R|RTail],[Del|DelTail],[Ins|InsTail]) :-
%                                             append([Y], YTail, YFull),
%                                             compare_word_sentence(X,YFull,Z,Del_,Ins_),
%                                             Del_ = [],
%                                             Del = Del_,
%                                             Ins = Ins_,!,
%                                             compare_sentences(XTail,YTail,ZTail,RTail,DelTail,InsTail),
%                                             compare_insert(Ins,Z__,R_),
%                                             nth0(0,RTail,RHead),
%                                             join_check(R_,RHead,R).



%
% compare_sentences([X|XTail],[Y|YTail],[Z|ZTail],[R|RTail]) :- XTail == [],
%                                                     base_check(X,Y,independence),
%                                                     ZTail = [],
%                                                     RTail = [],
%                                                     compare_sentences([],[],ZTail,RTail),!.
% compare_sentences([X|XTail],[Y|YTail],[Z|ZTail],[R|RTail]) :- XTail == [],
%                                                     base_check(X,Y,A),
%                                                     Z = A,
%                                                     R = A,
%                                                     ZTail = [],
%                                                     RTail = [],
%                                                     compare_sentences([],[],ZTail,RTail),!.
% compare_sentences([X|XTail],[Y|YTail],[Z|ZTail],[R|RTail]) :- YTail == [],
%                                                     base_check(X,Y,independence),
%                                                     Z = independence,
%                                                     compare_sentences(XTail,[Y],ZTail,RTail),!,
%                                                     % nth0(0,ZTail,ZHead),
%                                                     nth0(0,RTail,RHead),
%                                                     join_check(Z,RHead,R).
% compare_sentences([X|XTail],[Y|YTail],[X|ZTail],[R|RTail]) :- YTail == [],
%                                                     base_check(X,Y,A),
%                                                     Z = A,
%                                                     compare_sentences(XTail,[Y],ZTail,RTail),
%                                                     % nth0(0,ZTail,ZHead),
%                                                     nth0(0,RTail,RHead),
%                                                     join_check(Z,RHead,R).
% compare_sentences([X|XTail],[Y|YTail],[Z|ZTail],[R|RTail]) :- base_check(X,Y,independence),
%                                                     Z = independence,
%                                                     append([Y], YTail, YFull),
%                                                     compare_sentences(XTail,YFull,ZTail,RTail),
%                                                     % nth0(0,ZTail,ZHead),
%                                                     nth0(0,RTail,RHead),
%                                                     join_check(Z,RHead,R).
% compare_sentences([X|XTail],[Y|YTail],[Z|ZTail],[R|RTail]) :- base_check(X,Y,A),
%                                                     Z = A,
%                                                     append([Y], YTail, YFull),
%                                                     compare_sentences(XTail,YFull,ZTail,RTail),!,
%                                                     % nth0(0,ZTail,ZHead),
%                                                     nth0(0,RTail,RHead),
%                                                     join_check(Z,RHead,R).

% compare_word_sentence(X,[Y|YTail],Z,Del,InsTail) :-
%                                              YTail = [],
%                                              base_check(X,Y,A_),!,
%                                              A \= independence,
%                                              Z = A,
%                                              Del = [],
%                                              InsTail = [],
%                                              compare_word_sentence(X,[],Z,Del,InsTail).

% compare_word_sentence(X,[Y|YTail],Z,Del,[Ins|InsTail]) :-
%                                             base_check(X,Y,independence),!,
%                                             Ins = Y,
%                                             compare_word_sentence(X,YTail,Z,Del,InsTail).

% compare_insert([],[equivalence],[equivalence],1).
% compare_insert([],_,_,_) :- compare_insert([],[equivalence],[equivalence],1).
% compare_insert([Ins|InsTail],[Z|ZTail],[R|RTail],P) :- word(Ins,Z,P_),
%                                                      compare_insert(InsTail,ZTail,RTail,PTail),!,
%                                                      nth0(0,RTail,RHead),
%                                                      join_check(Z,RHead,R),
%                                                      P is P_ * PTail.