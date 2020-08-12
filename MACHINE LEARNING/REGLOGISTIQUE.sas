
/* Analyse descriptive */
proc means data=prema;
	class Sexe Evt_avt Evt_apr;
run;

/* 2. Modèle liant les évènements post vaccination et le sexe de l'enfant */
proc logistic data=prema;
	class Sexe;
	model Evt_apr = Sexe;
run;

/* 3. Modèles univariés */
proc logistic data=prema;
	model Evt_apr = Terme;
run;

proc logistic data=prema;
	model Evt_apr = Poids_nais;
run;

proc logistic data=prema;
	model Evt_apr = Age_corrige;
run;

proc logistic data=prema;
	model Evt_apr = Poids_vaccin;
run;

proc logistic data=prema;
	class Evt_avt;
	model Evt_apr = Evt_avt;
run;

/* 4. Modèle multivarié */
/* Attention, certaines variables sont a priori corrélées (les deux variables d'âge et les deux variables de poids) */

proc logistic data=prema;
	class Sexe Evt_avt;
	model Evt_apr = Sexe Terme_nais Poids_nais Evt_avt / selection=stepwise;
run;

proc logistic data=prema;
	class Sexe Evt_avt;
	model Evt_apr = Sexe Age_corrige Poids_vaccin Evt_avt / selection=stepwise;
run;

/* 5. Courbe ROC */
/* Il suffit d'ajouter l'option plots=roc */
proc logistic data=prema plots(only)=(roc(id=obs));
	class Sexe Evt_avt;
	model Evt_apr = Sexe Age_corrige Poids_vaccin Evt_avt / selection=stepwise;

run;
