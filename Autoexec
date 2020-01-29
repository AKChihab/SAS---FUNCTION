/*========================================================================*/
/*                     Script de connexion au serveur, données TERADATA   */
/*========================================================================*/

%macro connexion();
%let serveur=servinf.sasbpu93;
options comamid=tcp remote=&serveur;
/*signon noscript user=&tera_user pwd="{SAS002}ACC8B4514021183545C83395335B8C50" ;*/

/*signon noscript user=LIAKACH password="{SAS002}1A83BD415779A54D329A60C145AAD62F"
;*/
signon noscript user=zjel03p password=libgH257;


%syslput COMPUTER =%sysget(COMPUTERNAME);
rsubmit;
%defsuivi;
endrsubmit;
options yearcutoff = 1950;

libname ESP0 slibref=ESP0 server=&serveur;
libname SWORK slibref=WORK server=&serveur;
%FIN:

%mend connexion; 


rsubmit;

/* Accès avec user générique */

libname LIREF teradata database=TJEPRV_LIREF user=&tera_user pwd=&tera_pwd TDPID=&tera_srv defer=YES;

endrsubmit;



dm 'log;color note green ;

color source White;

color warning yellow;

color data White;

color background  black;

wsave;';

dm 'output;

color data       white;

color footn      blue;

color header blue;';

dm 'output;

color title      green;

color error      white;

color background black;

wsave';

dm "keydef F12 refresh ; output; winclose;";
/*dm "output; winclose;";*/

data _null_;
rc=SLEEP(3);
run;

dm "clear log ; clear output";
