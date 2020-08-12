/* Liste des fichiers dans un répértoire  Windows */ 

filename FILE pipe 'dir "Path" /b ';

data FILENAME;
  infile FILE dlm="¬";
  length FILE_NAME $1000;  /* Taille nom fichier */ 
  input FILE_NAME;
run;

