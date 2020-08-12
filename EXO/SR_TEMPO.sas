
/* Création de la libraire */
libname DM "C:\Users\PC\Desktop\Serie tempo";
run;

/*Importation des données*/
proc import datafile="C:\Users\PC\Desktop\Serie tempo\serie_projet2016.xls"
out= DM.serie
dbms='xls'
replace;
getnames=No;
run; quit;
/* Affichage de la table */
proc print data=DM.serie;
title " Valeurs de la série au cours du temps";
run;
/* Création d'une variable de temps */
data DM.serie;
set DM.serie;
t=_n_;
run;
/* Représentation graphique de la série */
proc sgplot data=DM.serie;
scatter y=A x=t;
run;
/* Supperposer la série à une droite affine de régression*/
proc gplot data=DM.serie;
plot A*t;
symbol1 V = DOT I = RL C = red ;
run; 
/*Etude descriptive de la série*/ 
proc univariate data=DM.serie;
var A;
run;
/* Regression linéaire */
proc reg data=DM.serie;
model A = t;
run; 
/* Modéliser la série par des processus ARMA en plus d'une constante */
/* Test de stationnarité */
proc arima data=DM.serie;
identify var=A nlag=30 stationarity=(adf=(2)) ; 
run;quit;
/* Serie non stationnaire et ACF decroit lentement donc on differencie la serie */
/* A(1) Nous differencions une fois : serie non stationnaire */
/* A(1,1) Serie stationnaire */
proc arima data=DM.serie;
/* identify : variable à modéliser  on spécifiant les termes de différenciation dela série*/
identify var=A(1,1) nlag=30 stationarity=(adf=(2)); 
run;quit;

/* Chercher les meilleurs p et q composantes de AR(p) et Ma(q) */
proc arima data=DM.serie;
identify var=A(1,1) nlag=30  stationarity=(adf=(2)) ;
estimate p=2   method=ml;  /*méthod d'estimation , P : autorégrissive du modéle*/
run;quit;

proc arima data=DM.serie;
identify var=A(1,1) nlag=30  stationarity=(adf=(2)); 
estimate p=2 q=5 method=ml; /*Q : moyenne mobile */
run;quit;



proc arima data=DM.serie;
identify var=A(1,1) esacf minic scan nlag=30; /* retrouver le meilleur p et q composante de AR(p) et Ma(q)  */
estimate p=2 q=5  noint method=ml; /*méthod d'estimation ;Q : moyenne mobile ; P : autorégrissive du modéle*/
forecast  back= 10 lead=20 id=t out=Dm.prev ; /*forecast: option de prévision lead : horizon de prédiction */
run;quit;

/* Etude de la variable residu (Valeur réelle - Valeur prédite) */
proc Univariate data=DM.prev;
var RESIDUAL;
run;
/* Prédiciton des termes de la serie   */
proc gplot data=DM.prev;
plot (A forecast L95 U95)*t / overlay;
run;quit;
/*   creation d'une table contenant que les 10 termes future         */ 
data dm.prevision;
set DM.prev (firstobs= 500 Obs=510);
run;
/*presentation graphique des 10 futures termes*/
proc gplot data=DM.prevision;
 symbol i=spline v=circle h=2;
plot (forecast L95 U95)*t / overlay ;
run;quit;
