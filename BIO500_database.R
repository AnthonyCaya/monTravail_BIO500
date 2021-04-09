setwd("~/École/UdeS/Session Hiver 2021/BIO500/Travail")

library(RSQLite)
library(dplyr)

con <- dbConnect(SQLite(), dbname="reseau1.db")

dbConnect(con)

#À NE PAS REFAIRE SINON ACCUMULATION DES DONNÉES
#-------------------------------------------------------------------------------------------------------------
  

#Création des tables avec clés primaires et étrangères
noeuds_sql<-'
  CREATE TABLE noeuds (
  nom VARCHAR(50),
  session_debut VARCHAR(3),
  programme VARCHAR(20),
  coop BOOLEAN(1),
  BIO500 BOOLEAN(1),
  PRIMARY KEY (nom)
);'

dbSendQuery(con, noeuds_sql)

collaborations_sql<-'
  CREATE TABLE collaborations (
  etudiant1 VARCHAR(50),
  etudiant2 VARCHAR(50),
  cours VARCHAR(6),
  session VARCHAR(3),
  PRIMARY KEY (etudiant1, etudiant2, cours),
  FOREIGN KEY (etudiant1) REFERENCES noeuds(nom),
  FOREIGN KEY (etudiant2) REFERENCES noeuds(nom),
  FOREIGN KEY (cours) REFERENCES cours(sigle)
);'

dbSendQuery(con, collaborations_sql)

cours_sql<-'
  CREATE TABLE cours (
  sigle VARCHAR(6),
  credits INTEGER(1),
  presentiel BOOLEAN(1),
  libre BOOLEAN(1),
  PRIMARY KEY (sigle)
);'

dbSendQuery(con, cours_sql)

dbListTables(con)

# Lecture des fichiers CSV
bd_noeuds <- read.csv2(file ='noeuds.csv' )
bd_cours <- read.csv2(file = 'cours.csv')
bd_collaborations <- read.csv2(file = 'collaborations.csv')
rbin()


# Injection des enregistrements dans la BD
dbWriteTable(con, append = TRUE, name = "noeuds", value = bd_noeuds, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "collaborations", value = bd_collaborations, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "cours", value = bd_cours, row.names = FALSE)


#-------------------------------------------------------------------------------------------------------------


#étape à réaliser à la fin de l'utiisation de celle-ci pour les requêtes  
dbDisconnect(con)
