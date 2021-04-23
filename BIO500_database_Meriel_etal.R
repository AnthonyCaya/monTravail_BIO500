#À RÉALISER COMME PREMIÈRE ÉTAPE


#setwd selon son propre emplacement des fichiers excel. Ne pas recopier cette ligne!!
setwd("~/École/UdeS/Session Hiver 2021/BIO500/Travail")

library(RSQLite)

con <- dbConnect(SQLite(), dbname="reseau1.db")

dbConnect(con)

#À NE PAS REFAIRE SI la base de donnée est déjà existante sinon ACCUMULATION DES DONNÉES
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

# Lecture des fichiers CSV noeuds et changement des noms de colonnes(en oubliant le fichier Auger_etal_noeuds, car informations
#répétées dans les autres et mal remplies (manque une colonne))
noeuds1 <- read.csv2(file ='AABBB_noeuds.csv' )
  colnames(noeuds1) <- c("nom","session_debut","programme","coop","BIO500")
noeuds2 <- read.csv2(file ='Drouin_etal_noeuds.csv' )
  colnames(noeuds2) <- c("nom","session_debut","programme","coop","BIO500")
noeuds3 <- read.csv2(file ='Meriel_etal_noeuds.csv' )
  colnames(noeuds3) <- c("nom","session_debut","programme","coop","BIO500")
noeuds4 <- read.csv2(file ='Teamdefeu_noeuds.csv' )
  colnames(noeuds4) <- c("nom","session_debut","programme","coop","BIO500")
noeuds5 <- read.csv2(file ='Vachon_etal_noeuds.csv' )
  colnames(noeuds5) <- c("nom","session_debut","programme","coop","BIO500")
  #fusionner les différents fichiers noeuds en un
  noeuds <-rbind(noeuds1,noeuds2,noeuds3,noeuds4,noeuds5)
    #Enlever les duplicatas pour éviter une erreur de dédoublement des clés lors de l'injection dans la base de données
    allo<- duplicated(noeuds[,1])
    bd_noeuds = subset(noeuds, allo == FALSE)
  


# Lecture des fichiers CSV cours et changement des noms de colonnes
cours1 <- read.csv2(file = 'AABBB_cours.csv')
  colnames(cours1) <- c("sigle","credits","presentiel","libre")
cours2 <- read.csv2(file ='Auger_etal_cours.csv' )
  colnames(cours2) <- c("sigle","credits","presentiel","libre")
cours3 <- read.csv2(file ='Drouin_etal_cours.csv' )
  colnames(cours3) <- c("sigle","credits","presentiel","libre")
cours4 <- read.csv2(file ='Meriel_etal_cours.csv' )
  colnames(cours4) <- c("sigle","credits","presentiel","libre")
cours5 <- read.csv2(file ='Teamdefeu_cours.csv' )
  colnames(cours5) <- c("sigle","credits","presentiel","libre")
cours6 <- read.csv2(file ='Vachon_etal_cours.csv' )
  colnames(cours6) <- c("sigle","credits","presentiel","libre")
  #fusionner les différents fichiers cours en un
  cours <-rbind(cours1,cours2,cours3,cours4,cours5,cours6)
  #Enlever les duplicatas pour éviter une erreur de dédoublement des clés lors de l'injection dans la base de données
    allo<- duplicated(cours[,1])
    bd_cours = subset(cours, allo == FALSE)



# Lecture des fichiers CSV collaborations et changement des noms de colonnes
collaborations1 <- read.csv2(file = 'AABBB_collaborations.csv')
  colnames(collaborations1) <- c("etudiant1","etudiant2","cours","session")
collaborations2.1 <- read.csv2(file ='Auger_etal_collaborations.csv' )
  #Enlever les colonnes excédantaires du document Auger_etal_collaborations
collaborations2 <- collaborations2.1[,c(1,3,5,6)]
  colnames(collaborations2) <- c("etudiant1","etudiant2","cours","session")
collaborations3 <- read.csv2(file ='Drouin_etal_collaborations.csv' )
  colnames(collaborations3) <- c("etudiant1","etudiant2","cours","session")
collaborations4 <- read.csv2(file ='Meriel_etal_collaborations.csv' )
  colnames(collaborations4) <- c("etudiant1","etudiant2","cours","session")
collaborations5 <- read.csv2(file ='Teamdefeu_collaborations.csv' )
  colnames(collaborations5) <- c("etudiant1","etudiant2","cours","session")
collaborations6 <- read.csv2(file ='Vachon_etal_collaborations.csv' )
  colnames(collaborations6) <- c("etudiant1","etudiant2","cours","session")
  #fusionner les différents fichiers collaborations en un
  collaborations <-rbind(collaborations1,collaborations2,collaborations3,collaborations4,collaborations5,collaborations6)
  #Enlever les duplicatas pour éviter une erreur de dédoublement des clés lors de l'injection dans la base de données et
    #un NA dans les colonnes etudiant1 et etudiant2 qui n'a pas de sens
    allo <- duplicated(collaborations[,1:3])
    bd_collaborations = na.omit(subset(collaborations, allo == FALSE))

  

# Injection des enregistrements dans la base de données
dbWriteTable(con, append = TRUE, name = "noeuds", value = bd_noeuds, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "collaborations", value = bd_collaborations, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "cours", value = bd_cours, row.names = FALSE)

#Modifier données A21 vers A20 (erreur confirmé de l'étudiant responsable)
update <- "UPDATE collaborations SET session = 'A20' WHERE session = 'A21';"
dbGetQuery(con,update)
#Modifier données ouelette_laury vers ouellet_laury (erreur de saisie vérifiée)
update2 <- "UPDATE collaborations SET etudiant1 = 'ouellet_laury' WHERE etudiant1 = 'ouelette_laury';"
dbGetQuery(con,update2)

#Enlever plusieurs Data pour permettre d'aérer l'environnement de travail (plus nécessaires pour la suite)#
remove(collaborations,collaborations1,collaborations2,collaborations2.1,collaborations3,collaborations4,
       collaborations5,collaborations6,cours,cours1,cours2,cours3,cours4,cours5,cours6,noeuds,noeuds1,noeuds2,
       noeuds3,noeuds4,noeuds5,allo)
#-------------------------------------------------------------------------------------------------------------


#étape pour fermer la base de données, à ne faire qu'à la fin de son utilisation.#  
dbDisconnect(con)
