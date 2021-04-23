#effectuer ces requêtes une fois la base de données créée

#Requête pour aller chercher la table collaboration
req <- "SELECT etudiant1, etudiant2, cours, session FROM collaborations"
collaborations.table <- dbGetQuery(con, req)


#Requête du nombre de liens différents par étudiant avant covid [H18 à H20]
req1 <- "SELECT etudiant1, count(etudiant1) AS nb_liens FROM (
  SELECT DISTINCT etudiant1, etudiant2
    FROM collaborations WHERE session LIKE '%A18%' OR session LIKE '%H19%' OR session LIKE '%E19%' OR session LIKE'%A19%' OR session LIKE'%H20%')
GROUP BY etudiant1 ;"
Nbliens_AvCovid <- dbGetQuery(con, req1)
head(Nbliens_AvCovid)


#Requête des liens entre étudiant avant covid (paires d'étudiants uniques)
req2 <- "SELECT DISTINCT etudiant1, etudiant2
    FROM collaborations WHERE session LIKE '%A18%' OR session LIKE '%H19%' OR session LIKE '%E19%' OR session LIKE'%A19%' OR session LIKE'%H20%'
GROUP BY etudiant1, etudiant2 ;"
liens_AvCovid <- dbGetQuery(con, req2)
head(liens_AvCovid)


#Requête du nombre de liens différents par étudiant après covid [E20 à H21]
req3 <- "SELECT etudiant1, count(etudiant1) AS nb_liens FROM (
  SELECT DISTINCT etudiant1, etudiant2
    FROM collaborations WHERE session LIKE '%E20%' OR session LIKE '%A20%' OR session LIKE '%H21%')
GROUP BY etudiant1 ;"
Nbliens_ApCovid <- dbGetQuery(con, req3)
head(Nbliens_ApCovid)


#Requête des liens entre étudiant après covid (paires d'étudiants uniques)
req4 <- "SELECT DISTINCT etudiant1, etudiant2
    FROM collaborations WHERE session LIKE '%A18%' OR session LIKE '%E20%' OR session LIKE '%A20%' OR session LIKE '%H21%'
GROUP BY etudiant1, etudiant2 ;"
liens_ApCovid <- dbGetQuery(con, req4)
head(liens_ApCovid)


#Requête du nombre de liens différents par étudiant par session 
req5 <- "SELECT etudiant1, count(etudiant1) AS nb_liens, session FROM (
  SELECT DISTINCT etudiant1, etudiant2, session
    FROM collaborations)
GROUP BY etudiant1, session ;"
Nbliens_se <- dbGetQuery(con, req5)
head(Nbliens_se)

