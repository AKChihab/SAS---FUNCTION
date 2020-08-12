/*==================================================================*/
/*Auteur : Antoine Cochez						                    */
/*Nom    : Exercice0_170103.sas                                     */
/*But    : importe le fichier FILM.txt					            */
/*Date   : 01/2003                                      	        */
/*Maj    : 01/2003                                          	    */
/*==================================================================*/



/*********************************************************************/
/*                          Ne plus modifier                         */
/*********************************************************************/	
proc format library = work.formats
	fmtlib
	;
	value $ FILMF
		'BOND'= 'James Bond'
		;
	picture Eutro 	low-<0 ='00 000 000 009 Euro'
							(mult=6.55957 prefix = '-')
					0-high ='00 000 000 009 Euro'
							(mult=6.55957);
run;
filename Monfic "!racine\Fichext\FILM.txt";
data Projlib.FILM(label="Film");
	Attrib FILM			Length=$7./*nb de characteres */
 						Label="Nom du film"
						format=$7. 
						informat=$7.;
	Attrib RECETTE		Length=8./*nb d'octets*/
 						Label="Recette"
						format=8.  /*format de stockage */
						informat=8.;  /*format de lecture */
	Attrib PAYS 		Length=$2.
 						Label="PAYS"
						format=$2. 
						informat=$2.;
	Attrib ANNEE 		Length=$4.
 						Label="ANNEE"
						format=$4. 
						informat=$4.;
		
	
	infile monfic missover ;
	INPUT 	FILM $ 1-7
	 		RECETTE $ 8-14
			PAYS $ 15-16 
			ANNEE $ 17-21 @
			;
			
	
run;	

/*exo1*/

data dess.salaire;
attrib serv label = "serveur";
attrib snet LENGth = 8.
			format = Eutro18.2
			informat = 8.2;
input serv 1-3 nom $ 5-14 sexe $ 16 snet 18-25 sbrut 27-34;/* input ;va lire les variables(chaque ligne ) (stocker dans le tableau)  precisison du champs et $ signifie que c'est des characteres */
cards;
917 DUPONT     F 13381.00 19446.00
918 DUCHEMIN   M  4487.00  6208.00
917 GAILLARD   M 15550.00 24709.00
914 LAMBERT    F  5309.00  7678.00
918 PERSE      F 15788.00 25431.00
916 RICHARD    M  6385.00  9457.00
914 ROBERT     M  5831.00  7984.00
;
data salaire;
set dess.salaire;

proc print;
title 'Listage du tableau salaire';
run;/*execute*/

/*exo2*/

data salaire2;
set salaire;/*crée la variable salaire*/
retenue=sbrut-snet;
label serv='Service'
      nom='Nom'
      sexe='Sexe'
      snet='Salaire net'
      sbrut='Salaire brut'
      retenue='Retenue'
;
proc print label;
title 'Listage des salaires et retenue';
run;

/*exo3*/

data femmes;
set salaire;
/*if sexe='M' then delete;*//*si sexe masculin on nettoie*/
/* on peut mettre */  if sexe='F';    /*il est preferable de nettoyer si sexe est feminin*/
proc print;
title 'Salaire des femmes';
run;

/*exo4*/

data general;
set salaire;
drop snet sbrut;/*on jette snet et sbrut*/

proc print noobs;/*noobs : on ne veut pas les numéros des observations*/
title 'Renseignements généraux';/*le titre reste tant que l'on ne le change pas*/
run;






/*exo5*/

data hommes femmes;/*cree deux fichiers temporaires Work.hommes et ..*/
set salaire;
drop snet sbrut;
if sexe='M' then output hommes;/*sortie dans fichier suivant le sexe*/
else output femmes;

proc print ;/*imprime par default le dernier fichier cree*/
title 'Renseignements généraux sur les femmes';
run;

proc print data=hommes;/*precision necessaire sinon fichier femme*/
title 'Renseignements généraux sur les hommes';
run;

/*exo5bis*/

data femmes hommes;
set salaire;
drop snet sbrut;
if sexe='M' then output hommes;
else output femmes;

proc print ;
title 'Renseignements généraux sur les hommes';
run;

proc print data=femmes;
title 'Renseignements généraux sur les femmes';
run;

/*exo6*/

data general(keep=serv nom sexe) paie(keep=nom snet sbrut);/*cree deux fichiers */
/* pour general on peut ecrire aussi ( drop=snet sbrut)
et pour paie (drop=serv sexe) */
set salaire;/*lire salaire*/

proc print data=general;
title 'renseignements generaux';
run;

proc print ;
title 'renseignements paie';
run;

/*exo6bis*/

data general(keep=serv nom sexe) paie(keep=nom snet sbrut);
/* pour general on peut ecrire aussi ( drop=snet sbrut)
et pour paie (drop=serv sexe) */
set salaire;

proc print ;
title 'renseignements paie';
run;

proc print data=general;
title 'renseignements généraux';
run;
/*exo7*/

data tous;
set hommes femmes;/*concatenation des fichiers*/

proc print;
title 'résultat de la concaténation';
run;

/*exo8*/

proc sort data=hommes;by nom;
proc sort data=femmes;by nom;
data toustrie;
set hommes femmes;
by nom;
proc print;
title 'résultat de l'' interclassement';
run;

/* ou aussi
proc sort data=tous out=toustrie;
by nom;
run;
proc print;
title 'tableau trié';
run;*/

/*exo9*/

proc sort data=general;
by nom;
run;
proc sort data=paie;
by nom;
run;
data fusion;
merge general paie;
/*by nom; est inutile ici*/
proc print;
title "tableau fusion";
run;

/*exo10*/

data paie;
set paie;
if nom='LAMBERT' then delete;

data fusion;
merge general paie;
proc print;
title 'fusion une a une';/*plusieur lignes de texte possible*/
title2 'nombre d''observations differents';
run;







/*exo11*/

data fusion;
merge general paie;
by nom;
proc print;
title 'fusion suivant une variable';
title2 'nombre d''observations differents';
run;

/*exo12*/

data vetement;
input date $ vente;
cards;
3JAN2000 223.95
4JAN2000 387.80
5JAN2000 229.30
6JAN2000 318.35
7JAN2000 519.10
;
data equip;
input date $ vente;
cards;
3JAN2000 492.30
4JAN2000 228.20
5JAN2000 542.95
6JAN2000 325.00
7JAN2000 733.60
;
data totvente;
merge vetement equip;
by date;
proc print;
title 'fusion des fichiers ayant des variables de même nom';
title2 'autre que la BY variable';
run;

/*exo13*/

data vetequip;
merge vetement (rename=(vente=v_vente))
      equip (rename=(vente=e_vente));
by date;
proc print;
 title 'fusion de fichiers ayant des variables de même nom' ;
 title2 'autre que la BY variable, en utilisant l''option rename';
run;












/*Exo14*/

data dess.budgetem;
infile 'd:\libro\dess\budget.dos';
length default = 3;
        Input id $ 1-4 sex $ 1 statut $ 2 pays $ 3-6
          prof 7-10 tran 11-14 mena 15-18 enfa 19-22 cour 23-26 toil 27-30
          repa 31-34 somm 35-38 tele 39-42 lois 43-46;
    label prof = 'profession' tran = 'transport' mena = 'ménage' 
      enfa = 'enfant'cour = 'courses' toil = 'toilette' 
repa = 'repas' somm = 'sommeil' tele = 'télévision' lois ='loisirs';
proc print;
run;
proc contents;
run;
proc print noobs;
run;
proc print noobs;
var mena tran sex;
run;

/*Exo15*/

data dess.budget1;
set dess.budgetem (obs=28);
proc print;
run;
proc contents;
run;
data budget2;
set dess.budgetem (firstobs=29);
proc print;
run;
proc contents;
run;

/*Exo16*/

data budget12;
set dess.budgetem;
        keep id sex statut pays tele lois;
proc print;
run;
proc contents;
run;

/*Exo17*/

proc contents data=dess._all_ position;
title 'contenu de la base dess';
run;

/*Exo18*/

proc sort data=dess.budget1 out=dess.tri1pays;
by pays;
run;
proc print;
by pays;
sumby pays;
title 'impression du fichier dess.budget1 par pays'; run;

/*Exo 19*/

proc means data=dess.budget1;
var prof tran;
title 'proc means pour description d''un fichier';
proc univariate ;
var prof tran cour;
title ' proc univariate pour description d''un fichier';
run;

/*Exo20*/

proc format;
value $sex 'F' = 'FEMMES' 'H' = 'HOMMES';
proc chart data = dess.budget1;
format sex $sex. ;
hbar prof/group=sex levels=27 ;
title 'histogramme par sexe de la variable profession';
run;

/*Exo21*/

proc sort data = dess.budget1 out = triesex;
by sex;
proc plot data = triesex;
by sex;
plot prof*tran = pays prof*lois ='+' / overlay;
  title ' croisement des variables profession et transport ou loisirs par sexe';
  title2 ' les points étant repérés par l''initiale du pays ou le signe +';
run;
proc print;
run;

/*Exo22*/

proc format;
value $fsex 'F'='2'  'H'= '1' other='.';
data dess.budgtcod ; set dess.budgetem;
length sexr profr tranr 3;
sexr=put(sex,$fsex.);
tranr = (tran>=0) + (tran>=79) + (tran>=106);
profr = (prof>=0) + (prof>=176) + (prof>=459) + (prof>=595) + (prof>=650);
proc freq data = dess.budgtcod;
tables sex sexr profr tranr;
title 'tri à plat pour vérifier le recodage';
run;
proc print data=dess.budgtcod ;
run;

/*Exo23*/

proc rank data=dess.budgetem groups=3 ties=high out = fichrank;
var prof;
proc print;
title 'utilisation de la procédure rank';
title2 'pour éclatement en classes d''effectifs égaux';
run;



/*Exo24*/

proc rank data=dess.budgetem groups=3 ties=high out = fichrank;
/*var prof;
ranks rankprof;*/
proc print;
title 'utilisation de la procédure rank';
title2 'pour éclatement en classes d''effectifs égaux';
run;

/*Exo25*/

data discomp;
set dess.budgtcod (obs=25);
array A(sexr) sex1-sex2;
array B(profr) pro1-pro5;
array C(tranr) tra1-tra3;
array Y A B C ;
array Z sex1--tra3;
do over Z ; Z=0; end;
do over Y; Y=1;end;
keep id sex1--tra3;
proc print data=discomp;
title 'fichier discomp des variables dichotomisées';
run;

/*Exo26*/

proc corr data = discomp sscp out=fichburt nocorr noprint nosimple;
var sex1--tra3;
proc print data= fichburt;
title 'tableau de burt obtenu par proc corr';
run;

/*Exo27*/

data dedconnu;
set dess.budgtcod;
profd = 5 - profr ;
proc contents data = dedconnu;
title 'fichier dedconnu :profr et son complément à 5 profd';
run;
proc print data = dedconnu (keep =id profr profd obs=5);
run;

/*Exo28*/

proc summary data=dess.budgtcod;
var profr;
output out=notmax max=maxprofr;
proc print data=notmax;
title 'note maximum de profr';
data dedinco;
if eof then go to A;
set notmax end=eof;
retain maxprofr;
A:set dess.budgtcod;
profc=maxprofr-profr; run;
proc print data=dedinco (keep=id profr profc obs=5);
title 'fichier dedinco :profr et son complément à';
title2 'sa valeur maximale dans dess.budgtcod'; run;
/*Exo29*/
proc print data=dess.budget1;
title 'fichier dess.budget1;run;
proc summary data=dess.budget1;
class sex statut ;
var prof--lois;
output out=cdg mean=;
proc print data=cdg;
title 'fichier cdg des centres de gravité';
run;

/*Exo30*/

data dess.budget3;
set dess.budget1 (in=in1)
    cdg (in=in2 firstobs=2 drop =_freq_ _type_);
if in1 then do;id2=id;idsup=1;end;
else if in2 then do ;id2=sex!!statut;idsup=2;end;
proc print data=dess.budget3;
title 'fichier dess.budget3 contenant concaténés les 2 fichiers';
title2 'avec indication du fichier à l''aide de idsup';
run;

\*Exo31*/

Proc format;
value tr 1='un'  2= 'deux' 3='trois';
/* value definit le format tr pour une variable numerique*/
data essai;
input munici $ poblac categ;
cards;
bolog 12314  1
loinb   4564   2
retb 3421  1
zear  56743  3
btre   453298   2
;
proc freq ;
/* on lit la variable numerique categ suivant le format tr*/
format categ tr.;
tables munici poblac categ;
run;
/* on verifie que la variable categ reste numerique*/
proc contents;
run;

