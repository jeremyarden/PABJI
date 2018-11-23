:- dynamic(peta/4).
:- dynamic(dz/4).
:- dynamic(enemy/4).
:- dynamic(inventory/1).
:- dynamic(armor/1).
:- dynamic(health/1).
:- dynamic(player/5).
:- dynamic(ammo/2).
:- dynamic(pelindung/2).
:- dynamic(medicine/2).
:- dynamic(ticker/1).
:- dynamic(npc/4).
damage(ak47,60).
damage(pistol,20).

health(100).
senjata(ak47).
senjata(m4).
senjata(pistol).
armor(0).
pelindung(helm, 30).
pelindung(baju, 20).
pelindung(kevlar,60).

medicine(betadine,10).
medicine(bandage,20).

ammo(magazineA, 5).
ammo(magazineB,10).
ammo(magazineC,15).


search_list([X|_],X).
search_list([X | Tail],Y):- search_list(Tail,Y).

/* append([],X,X).                           
append([X|Y],Z,[X|W]) :- append(Y,Z,W). */

init_map(X,Y):- X=<10,Y==10, assertz(peta(X,Y,[],forest)) ,W is X+1, Z is 1, init_map(W,Z),!.
init_map(X,Y):- X=<10, Y<10,assertz(peta(X,Y,[],forest)), W is Y+1, init_map(X,W).

init_medicine(Jenis) :- Jenis ==1,random(1,10,X), random(1,10,Y),retract(peta(X,Y,L,B)), append(L,[betadine],A),assertz(peta(X,Y,A,B)).
init_medicine(Jenis) :- Jenis ==2,random(1,10,X), random(1,10,Y),retract(peta(X,Y,L,B)), append(L,[bandage],A),assertz(peta(X,Y,A,B)).

init_weapon(Jenis) :- Jenis ==1,random(1,10,X),random(1,10,Y),retract(peta(X,Y,L,B)), append(L,[ak47],A),assertz(peta(X,Y,A,B)).
init_weapon(Jenis) :- Jenis ==2,random(1,10,X),random(1,10,Y),retract(peta(X,Y,L,B)), append(L,[m4],A),assertz(peta(X,Y,A,B)).
init_weapon(Jenis) :- Jenis ==3,random(1,10,X),random(1,10,Y),retract(peta(X,Y,L,B)), append(L,[pistol],A),assertz(peta(X,Y,A,B)).

init_armor(Jenis) :- Jenis==1,random(1,10,X),random(1,10,Y),retract(peta(X,Y,L,B)), append(L,[baju],A),assertz(peta(X,Y,A,B)).
init_armor(Jenis) :- Jenis==2,random(1,10,X),random(1,10,Y),retract(peta(X,Y,L,B)), append(L,[helm],A),assertz(peta(X,Y,A,B)).
init_armor(Jenis) :- Jenis==3,random(1,10,X),random(1,10,Y),retract(peta(X,Y,L,B)), append(L,[kevlar],A),assertz(peta(X,Y,A,B)).

init_ammo(Jenis) :- Jenis ==1,random(1,10,X),random(1,10,Y),retract(peta(X,Y,L,B)), append(L,[magazineB],A),assertz(peta(X,Y,A,B)).
init_ammo(Jenis) :- Jenis ==2,random(1,10,X),random(1,10,Y),retract(peta(X,Y,L,B)), append(L,[magazineB],A),assertz(peta(X,Y,A,B)).
init_ammo(Jenis) :- Jenis ==3,random(1,10,X),random(1,10,Y),retract(peta(X,Y,L,B)), append(L,[magazineB],A),assertz(peta(X,Y,A,B)).

init_barang(X) :- X>0,random(1,3,Jenis), init_medicine(Jenis), init_weapon(Jenis), init_armor(Jenis), init_ammo(Jenis), W is X-1, init_barang(W).

init_NPC(A1) :- A1>0, random(1,10,X),random(1,10,Y),retract(peta(X,Y,L,B)), append(L,[enemy],A),assertz(peta(X,Y,A,B)),assertz(npc(X,Y,100,30)),A2 is A1-1, init_NPC(A2).

print_dz(X,Y):-dz(Kiri,Atas,Kanan,Bawah), (X>=Bawah;X=<Atas; Y>=Kanan;Y=<Kiri),write('X '),!.
print_dz(X,Y) :- player(W,Z,_,_,_),X==W,Y==Z,write('P '),!.
print_dz(X,Y) :- write('- ').

print_map(X,Y):- X>10,!.
print_map(X,Y):- X=<10,Y==10,write('X '),nl,W is X+1, Z is 1, print_map(W,Z),!.
print_map(X,Y):- X=<10, Y<10, print_dz(X,Y), W is Y+1,print_map(X,W).

tesSearch(X,Y) :- peta(X,Y,L,_),search_list(L,ammo),!. 
deleteitem(X,Y) :- retract(peta(X,Y,L,B)),search_list(L,ammo),select(ammo,L,W),assertz(peta(X,Y,W,B)),!.

print_item(X,Y,L):-dz(Kiri,Atas,Kanan,Bawah), (X>=Bawah;X=<Atas; Y>=Kanan;Y=<Kiri),write('X '),!.
print_item(X,Y,L):-search_list(L,enemy),write('E '),!.
print_item(X,Y,L):-search_list(L,betadine),write('M '),!.
print_item(X,Y,L):-search_list(L,ak47),write('W '),!.
print_item(X,Y,L):-search_list(L,baju),write('A '),!.
print_item(X,Y,L):-search_list(L,magazineB),write('O '),!.
print_item(X,Y,L):-player(W,Z,_,_,_),X==W,Y==Z,write('P '),!.
print_item(X,Y,L):-write('- ').


print_look(X,Y,Xak,Yak):- X>Xak,!.
print_look(X,Y,Xak,Yak):- X=<Xak,Y==Yak,peta(X,Y,L,_),print_item(X,Y,L),nl,W is X+1, player(A,B,_,_,_),Z is B-1, print_look(W,Z,Xak,Yak),!.
print_look(X,Y,Xak,Yak):- X=<Xak, Y<Yak, peta(X,Y,L,_),print_item(X,Y,L), W is Y+1,print_look(X,W,Xak,Yak),!.

look :-player(X,Y,_,_,_),W is X-1, C is Y-1,A is X+1,B is Y+1,print_look(W,C,A,B),!.

init_peta :-retractall(peta(_,_,_,_)),\+init_map(1,1),\+init_barang(18),\+init_NPC(10),!.

peta :- print_map(1,1).

a :- player(_,Y,_,_,_), dz(Kiri,_,_,_), (Y-1) =< Kiri, W is Y-1, retract(health(_)), assertz(health(0)), retract(player(X,Y,Weapon,Ammo,Inventory)), assertz(player(X, W, Weapon, Ammo, Inventory)), write('mampus'), !.
a :- player(_,Y,_,_,_), dz(Kiri,_,_,_), (Y-1) > Kiri, W is Y-1, retract(player(X,Y,Weapon,Ammo,Inventory)), assertz(player(X, W, Weapon, Ammo, Inventory)),peta, !.

w :- player(X,_,_,_,_), dz(_,Atas,_,_), (X-1) =< Atas, W is X-1, retract(health(_)), assertz(health(0)), retract(player(X,Y,Weapon,Ammo,Inventory)), assertz(player(W, Y, Weapon, Ammo, Inventory)), write('mampus'), !.
w :- player(X,_,_,_,_), dz(_,Atas,_,_), (X-1) > Atas, W is X-1, retract(player(X,Y,Weapon,Ammo,Inventory)), assertz(player(W, Y, Weapon, Ammo, Inventory)),peta, !.

s :- player(X,_,_,_,_), dz(_,_,_,Bawah), (X+1) >= Bawah, W is X+1, retract(health(_)), assertz(health(0)), retract(player(X,Y,Weapon,Ammo,Inventory)), assertz(player(W, Y, Weapon, Ammo, Inventory)), write('mampus'), !.
s :- player(X,_,_,_,_), dz(_,_,_, Bawah), (X+1) < Bawah, W is X+1, retract(player(X,Y,Weapon,Ammo,Inventory)), assertz(player(W, Y, Weapon, Ammo, Inventory)), peta,!.

d :- player(_,Y,_,_,_), dz(_,_,Kanan,_), (Y+1) >= Kanan, W is Y+1, retract(health(_)), assertz(health(0)), retract(player(X,Y,Weapon,Ammo,Inventory)), assertz(player(X, W, Weapon, Ammo, Inventory)), write('mampus'), !.
d :- player(_,Y,_,_,_), dz(_,_,Kanan,_), (Y+1) < Kanan, W is Y+1, retract(player(X,Y,Weapon,Ammo,Inventory)), assertz(player(X, W, Weapon, Ammo, Inventory)), peta,!.

status :- health(X), write('Health : '), write(X), nl,
          armor(Y), write('Armor : '), write(Y), nl,
          player(_, _, Weapon, _, _), write('Weapon : '), write(Weapon), nl,
          player(_, _, _, Ammo, _), write('Ammo : '), write(Ammo), nl,
          findall(Item, inventory(Item), Inventory), write('Inventory : '), write(Inventory), !.


/*fungsi*/


bag(10).

pakai(X):- inventory(X),senjata(X),retract(player(X1,X2,X3,X4,X5)),assertz(inventory(X3)),assertz(player(X1,X2,X,X4,X5)),retract(inventory(X)),!.
pakai(X):- inventory(X),medicine(X,Y),health(A),A==100,write('health penuh'),!.
pakai(X):- inventory(X),medicine(X,Y),health(A),Z is A+Y,Z=<100,retract(health(A)),assertz(health(Z)),retract(inventory(X)),retract(player(X1,X2,X3,X4,X5)),X51 is X5-1,assertz(player(X1,X2,X3,X4,X51)),!.
pakai(X):- inventory(X),medicine(X,Y),health(A),Z is A+Y,Z>100,Q is 100,write('a'),retract(inventory(X)),retract(health(A)),assertz(health(Q)),retract(player(X1,X2,X3,X4,X5)),X51 is X5-1,assertz(player(X1,X2,X3,X4,X51)),!.
pakai(X):- inventory(X),ammo(X,M),retract(player(X1,X2,X3,X4,X5)),retract(inventory(X)),X51 is X5-1,Z is X4+M,assertz(player(X1,X2,X3,Z,X51)),!.
pakai(X):- inventory(X),pelindung(X,Y),retract(armor(Q)),U is Q+Y,assertz(armor(U)),retract(inventory(X)),!.

take(A):- player(X,Y,_,_,L),bag(Cap),L==Cap,write('inventory penuh'),!.
take(A):-peta(X1,X2,T,Map),player(X1,X2,X3,X4,L),search_list(T,A),retract(player(X1,X2,X3,X4,L)),retract(peta(X1,X2,T,Map)),select(A,T,T1),asserta(peta(X1,X2,T1,Map)),bag(Cap),L<Cap,asserta(inventory(A)),L1 is L+1,asserta(player(X1,X2,X3,X4,L1)),!.


deletelist(X,[],[]).
deletelist(X,[X|T],T).
deletelist(X,[H|T],[H|Z]):- X\=H,deletelist(X,T,Z).
searchlist([X|_],X).
searchlist([H|T],X):- H\=X,searchlist(T,X).

drop(X):- inventory(X),player(X1,X2,X3,X4,Z),retract(player(X1,X2,X3,X4,Z)),D is Z-1,asserta(player(X1,X2,X3,X4,D)),peta(X1,X2,C,U),retract(peta(X1,X2,C,U)),append([C],[X],I),asserta(peta(X1,X2,I,U)),retract(inventory(X)),!.

/* Enemy Health */
/* Berkurang */
decrease_health :-
    player(Xplayer,Yplayer,Weapon,_,_),
    retract(enemy(Xenemy,Yenemy,Health,Attack)),
    Xplayer == Xenemy,
    Yplayer == Yenemy,
    damage(Weapon,DamageTaken),
    NewHealth is Health-DamageTaken,
    NewHealth > 0,
    assertz(enemy(Xenemy,Yenemy,NewHealth,Attack)),!.
/* Mati */
decrease_health :-
    player(Xplayer,Yplayer,Weapon,_,_),
    retract(enemy(Xenemy,Yenemy,Health,Attack)),
    Xplayer == Xenemy,
    Yplayer == Yenemy,
    damage(Weapon,DamageTaken),
    NewHealth is Health-DamageTaken,
    NewHealth =< 0,!.

/*Generate all random move for enemy */
/* Make random move for an enemy until enemy can move */
/*random_move :-
    random(1,7,X),
    select_step(X),!.*/
npc_move :- \+npc(X,Y,Health,Att).
npc_move :- retract(npc(X,Y,Health,Att)), npc_move, random(1,7,Step),select_step(X,Y,Health,Att,Step).
/* Cara NPC bergerak */

select_step(X,Y,Health,Att,1) :- 
    step_e_up(X,Y,Health,Att), !.

select_step(X,Y,Health,Att,2) :-
    step_e_down(X,Y,Health,Att), !.

select_step(X,Y,Health,Att,3) :-
    step_e_left(X,Y,Health,Att), !.

select_step(X,Y,Health,Att,4) :-
    step_e_right(X,Y,Health,Att), !.

step_e_up(X1,Y1,Health,Attack) :-
    dz(_,Ats,_,_),
    retract(peta(X1,Y1,List,Map1)),
    select(enemy,List,List2),
    assertz(peta(X1,Y1,List2,Map1)),
    Z is X1-1,
    Z>Ats,
    assertz(npc(Z,Y1,Health,Attack)),
    retract(peta(Z,Y1,List3,Map2)),
    append([enemy],List3,List4),
    assertz(peta(Z,Y1,List4,Map2)).

step_e_down(X,Y,Health,Attack) :-
    dz(_,_,_,Bwh),
    retract(peta(X,Y,List,Map1)),
    select(enemy,List,List2),
    assertz(peta(X,Y,List2,Map1)),
    Z is X+1,
    Z<Bwh,
    assertz(npc(Z,Y,Health,Attack)),
    retract(peta(Z,Y,List3,Map2)),
    append([enemy],List3,List4),
    assertz(peta(Z,Y,List4,Map2)).

step_e_left(X,Y,Health,Attack) :-
    dz(Kiri,_,_,_),
    retract(peta(X,Y,List,Map1)),
    select(enemy,List,List2),
    assertz(peta(X,Y,List2,Map1)),
    Z is Y-1,
    Z>Kiri,
    assertz(npc(X,Z,Health,Attack)),
    retract(peta(X,Z,List3,Map2)),
    append([enemy],List3,List4),
    assertz(peta(X,Z,List4,Map2)).

step_e_right(X,Y,Health,Attack) :-
    dz(_,_,Kanan,_),
    retract(peta(X,Y,List,Map1)),
    select(enemy,List,List2),
    assertz(peta(X,Y,List2,Map1)),
    Z is Y+1,
    Z<Kanan,
    assertz(npc(X,Z,Health,Attack)),
    retract(peta(X,Z,List3,Map2)),
    append([enemy],List3,List4),
    assertz(peta(X,Z,List4,Map2)).

/*Drop random item*/
random_object :-
    random(1,5,Object),
    drop_object(X,Y,Object),!.

drop_object(X,Y,1) :-
    retract(peta(X,Y,L,B)),
    append(L,[medicine],A),
    assertz(peta(X,Y,A,B)).

drop_object(X,Y,2) :-
    retract(peta(X,Y,L,B)),
    append(L,[weapon],A),
    assertz(peta(X,Y,A,B)).

drop_object(X,Y,3) :-
    retract(peta(X,Y,L,B)),
    append(L,[armor],A),
    assertz(peta(X,Y,A,B)).

drop_object(X,Y,4) :-
    retract(peta(X,Y,L,B)),
    append(L,[ammo],A),
    assertz(peta(X,Y,A,B)).

start :-
    write('  .''.'),nl,
    write(' (~~~~)'),nl,
    write('   ||'),nl,
    write(' __||__'),nl,
    write('|______|'),nl,
    write('  |  | _ ___________________________________________________'),nl,
    write('  |  ||o||||||||||||||||||||||||||||||||||||||||||||||||||||'),nl,
    write('  |  || ||||||||||||||||||||||||||||||||||||||||||||||||||||'),nl,
    write('  |  || ||||||||||||||||||||||||||||||||||||||||||||||||||||'),nl,                       
    write('  |  || ||||||||||||||||||||||||||||||||||||||||||||||||||||'),nl,                 
    write('  |  || ||||||||||||||||||||||||||||||||||||||||||||||||||||'),nl,
    write('  |  || ||||||||||||||||||||||||||||||||||||||||||||||||||||'),nl,
    write('  |  || ||||||||||||||||||||||||||||||||||||||||||||||||||||'),nl,
    write('  |  || |                                                  |'),nl,
    write('  |  || |                                                  |'),nl,
    write('  |  || |                                                  |'),nl,
    write('  |  || |                                                  |'),nl,
    write('  |  || |                                                  |'),nl,
    write('  |  || |                                                  |'),nl,
    write('  |  ||o|__________________________________________________|'),nl,
    write('  |  |'),nl,
    write('  |  |   Selamat Datang Pejuang Terpilih!'),nl,
    write('  |  |   Negara sedang membutuhkanmu. Hanya kamu yang dapat melaksanakan tugas ini.'),nl,
    write('  |  |   Tugasmu sederhana. Kalahkan semua musuh, dan menangkan pertempuran.'),nl,
    write('  |  |   Waspadalah! Karena musuh telah mengirim pasukan yang akan terus mendekat'),nl,
    write('  |  |'),nl,
    write('   ~~'),nl,
    nl,
    write('Perintah yang Tersedia :'),nl,
    write('start.          --------------- Memulai permainan.'),nl,
    write('help.           --------------- Memunculkan perintah yang tersedia.'),nl,
    write('quit.           --------------- Keluar dari permainan.'),nl,
    write('look.           --------------- Melihat benda-benda di sekitar.'),nl,
    write('n. s. e. w.     --------------- Bergerak.'),nl,
    write('map.            --------------- Menampilkan peta permainan.'),nl,
    write('take(Object).   --------------- Mengambil barang yang ada tanah.'),nl,
    write('drop(Object).   --------------- Membuang barang ke tanah.'),nl,
    write('use(Object).    --------------- Menggunakan barang yang dimiliki.'),nl,
    write('attack.         --------------- Menyerang musuh di dekat kita.'),nl,
    write('status.         --------------- Menampilkan status.'),nl,
    write('save(Filename). --------------- Menyimpan permainan.'),nl,
    write('load(Filename). --------------- Melanjutkan permainan yang telah disimpan.'),nl.

