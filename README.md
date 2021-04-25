# monTravail_BIO500

#Est-ce que les liens entre étudiants sont influencés par laCOVID-19?

  #Travail réalisé par Marc-Antoine Cyr, Clara Meriel et Anthony Caya

Le travail d'analyse a été réalisé à partir de plusieurs documents standardisés remplies indépendemment par plusieurs équipes. Ces documents comprennent les informations de la
collaboration de chacun des étudiants avec leurs compères tout au long de leur baccalauréat, des informations de chacun des étudiants mentionnés dans cette table et des
informations de chacun des cours auxquels les étudiants se sont vu être placé en équipe. Malgré quelque erreur de saisies ou d'incohérence, les documents ne furent pas
corrigés dans les fichiers, mais bien, lors de la création de la base de données à l'aide de R.

Voici les tables créées et leur variables:
             
             noeuds_sql<-'
              CREATE TABLE noeuds (
              nom VARCHAR(50),
              session_debut VARCHAR(3),
              programme VARCHAR(20),
              coop BOOLEAN(1),
              BIO500 BOOLEAN(1),
              PRIMARY KEY (nom)
            );'

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

            cours_sql<-'
              CREATE TABLE cours (
              sigle VARCHAR(6),
              credits INTEGER(1),
              presentiel BOOLEAN(1),
              libre BOOLEAN(1),
              PRIMARY KEY (sigle)
            );'

1.Pour commencer l'analyse des données veuiller commencer par lancer le code R: BIO500_database_Meriel_etal.R permettant la création de la base de données en n'oubliant pas 
de changer son répertoire de travail et en ommettant la dernière ligne du code qui sert à se déconnecter de la base de données tout juste créée.

2.Par la suite, lancer le code R: BIO500_request_Meriel_etal.R où figure les requêtes nécessaires aux analyses futures.

3.Pour continuer, lancer le code R: BIO500_figures_Meriel_etal.R où figure l'analyse et la conception des différents graphiques et tableaux.

4.Le dernier fichier ici présent, est un document zip (BIO500_LATEX_Meriel_etal.zip) où est entreposé le script LATEX de notre rapport, le fichier .bib de la bibliographie,
ainsi que les fichiers des images utilisés
