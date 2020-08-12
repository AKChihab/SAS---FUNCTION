/* TP CAH */


/* On importe la base de données */
proc import datafile='\\172.18.80.20\userdata\baey\Documents\My SAS Files\dogs.csv' out=data;
	delimiter=',';
	getnames=yes;
run;

/* On affiche la répartition des variables, qualitatives, à l'aide de la PROC FREQ */
proc freq data=data;
	tables Size Weight Velocity Intelligence Affectivity Aggressivness;
run;


/* I. CLASSIFICATION PAR MATRICE DE DISTANCE */
/* On construit une matrice de distance en utilisant une distance adaptée au cas de variables ordinales, par exemple la distance de Gower */
/* Attention de bien utiliser une méthode qui renvoie une DISTANCE et pas une similarité (typiquement ici, dgower et non pas gower)
proc distance data=data out=dist_data method=dgower;
	var ordinal(Size--Aggressivness);
	copy Type;
run;

/* On applique l'algorithme de Classification Ascendante Hiérarchique à la matrice de distance obtenue précédemment */
proc cluster data=dist_data method=ward out=tree plots=dendrogram;
	id Type;
run;

/* Pour tracer le graphe de la hauteur des branches du dendrogramme en fonction du nombre de classes, on ordonne préalablement les données 
 obtenues en sortie de la proc cluster par valeurs décroissantes de hauteur */
proc sort data=tree;
	by _HEIGHT_;
run;

/* On trace le graphe demandé, en utilisant les options d'interpolation entre points pour obtenir un graphe plus facilement interprétable visuellement */
proc gplot data=tree;
	plot _HEIGHT_*_NCL_;
	symbol interpol=join value=dot;
run;

/* On décide de garder 4 classes : on peut obtenir la répartition des individus dans les 4 classes à l'aide de la proc tree et de l'option "ncl" qui indique
 le nombre de classes que l'on souhaite obtenir */
proc tree data=tree ncl=4 out=data_cl4 noprint;
	id Type;
run;

/* La table en sortie de la procédure précédente, data_cl4, contient pour chaque individu, le numéro de classe à laquelle il a été classé */
/* On classe cette table, et la table de données initiale, par l'identifiant du chien, afin de pouvoir fusionner les deux tables */
proc sort data=data_cl4;
	by Type;
run;

proc sort data=data;
	by Type;
run;

/* Pour pouvoir fusionner 2 tables à l'aide de l'instruction "merge", les tables doivent avoir été préalablement ordonnées selon la variable permettant de fusionner */
data data_cluster4;
	merge data data_cl4;	
	by Type;
run;

/* On affiche la répartition des différentes variables de la table en fonction du cluster, afin de pouvoir interpréter plus facilement les résultats */
proc sort data=data_cluster4;
	by cluster;
run;
	
proc sgplot data=data_cluster4;
	vbar cluster / group=Size groupdisplay=cluster;
run;

proc sgplot data=data_cluster4;
	vbar cluster / group=Weight groupdisplay=cluster;
run;

proc sgplot data=data_cluster4;
	vbar cluster / group=Velocity groupdisplay=cluster;
run;

proc sgplot data=data_cluster4;
	vbar cluster / group=Affectivity groupdisplay=cluster;
run;

proc sgplot data=data_cluster4;
	vbar cluster / group=Intelligence groupdisplay=cluster;
run;

proc sgplot data=data_cluster4;
	vbar Intelligence / group=cluster groupdisplay=cluster;
run;

proc sgplot data=data_cluster4;
	vbar cluster / group=Aggressivness groupdisplay=cluster;
run;


/* En particulier, on retient que :
	- la classe 1 contient surtout des chiens moyens à gros, affectueux, rapides et plutôt intelligents, tels le boxer ou le dalmatien
	- la classe 2 contient uniquement des petits chiens, légers, affectueux et pas spécialement agressifs, tels le chihuahua
	- la classe 3 contient des chiens agressifs et peu affectueux, quelles que soient leurs tailles et leurs poids, tels le doberman
	- la classe 4 contient uniquement des grands chiens, plutôt lourds et pas agressifs, tels le Saint Bernard


/* II. CLASSIFICATION A PARTIR D'UNE ETAPE PRELIMINAIRE D'ACM */
/* On construit le tableau disjoinctif complet */
proc transreg data=data design noprint;
	model class (Size--Aggressivness/ Zero=None);
	id Type;
	output out = data_tdc (drop=_type_ _name_ intercept Size--Aggressivness);
run;

/* On procède à l'ACM du tableau disjonctif complet obtenu précédemment, en gardant un nombre de dimensions égale au nombre total de modalités moins le nombre de variables, soit 10 */
proc corresp data=data_tdc dimens=10 short;
	var SizeS_--AggressivnessAg_2;
	id Type;
	ods output colCoors=axes rowCoors=individus;
run;

/* On ne garde que les 6 premières dimensions */
proc corresp data=data_tdc dimens=10 short;
	var SizeS_--AggressivnessAg_2;
	id Type;
	ods output colCoors=axes rowCoors=individus;
run;

/* On applique l'algorithme de CAH sur les coordonnées des individus dans le plan de l'ACM */
proc cluster data=individus6dim method=ward out=tree_acm plots=dendrogram;
	id Label;
run;

/* Comme précédemment, on trace le graphe de la hauteur des branches du dendrogramme en fonction du nombre de classes */
proc sort data=tree_acm;
	by _HEIGHT_;
run;

proc gplot data=tree_acm;
	plot _HEIGHT_*_NCL_;
	symbol interpol=join value=dot;
run;

/* On coupe encore en 4 classes (la variable Type est devenue la variable Label lors de la procédure corresp ...) */
proc tree data=tree_acm ncl=4 out=tree_acm_cl4 noprint;
	id Label;
run;

/* On re-créé une variable Type pour pouvoir fusionner avec la table initiale */
data tree_acm_cl4;
	set tree_acm_cl4;
	Type=Label;
run;

proc sort data=tree_acm_cl4;
	by Type;
run;

data tree_acm_clusters;
	merge data tree_acm_cl4;
	by Type;
run;


/* On calcule les fréquences de chaque variable dans les classes obtenues */
proc freq data=tree_acm_clusters;
	tables CLUSTER*(Size Weight Velocity Intelligence Affectivity Aggressivness);
run;

/* On obtient les résultats suivants :
	- la classe 1 ne contient que des chiens de taille moyenne, de poids moyens, moyennement rapides, plutôt intelligents (mais cette variable ne discrimine pas bien les classes) et affectueux et pas aggressifs, tels le Boxer ou le Dalmatien
	- la classe 2 contient des chiens de petite taille, tous légers, plutôt lents, affectueux mais pouvant être agressifs ou non (cette variable ne discrimine pas bien cette classe), tels le bulldog
	- la classe 3 ne contient que des chiens de grande taille, tous plutôt moyennement lourds, plutôt rapides, plutôt pas affectueux, et pouvant être aggressifs ou non (cette variable ne discrimine pas bien cette classe), tels le lévrier ou le doberman
	- la classe 4 ne contient que des chiens de grande moyenne, tous très lourds, plutôt lents, pas affectueux, et plutôt agressifs, tels le Bull Mastiff
*/
 

