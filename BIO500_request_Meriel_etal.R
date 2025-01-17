#� R�ALISER UNE FOIS LA BASE DE DONN�ES CR��ES

#Requ�te pour aller chercher la table collaboration
req <- "SELECT etudiant1, etudiant2, cours, session FROM collaborations"
collaborations.table <- dbGetQuery(con, req)


#Requ�te du nombre de liens diff�rents par �tudiant avant covid [H18 � H20]
req1 <- "SELECT etudiant1, count(etudiant1) AS nb_liens FROM (
  SELECT DISTINCT etudiant1, etudiant2
    FROM collaborations WHERE session LIKE '%A18%' OR session LIKE '%H19%' OR session LIKE '%E19%' OR session LIKE'%A19%' OR session LIKE'%H20%')
GROUP BY etudiant1 ;"
Nbliens_AvCovid <- dbGetQuery(con, req1)
head(Nbliens_AvCovid)


#Requ�te des liens entre �tudiant avant covid (paires d'�tudiants uniques)
req2 <- "SELECT DISTINCT etudiant1, etudiant2
    FROM collaborations WHERE session LIKE '%A18%' OR session LIKE '%H19%' OR session LIKE '%E19%' OR session LIKE'%A19%' OR session LIKE'%H20%'
GROUP BY etudiant1, etudiant2 ;"
liens_AvCovid <- dbGetQuery(con, req2)
head(liens_AvCovid)


#Requ�te du nombre de liens diff�rents par �tudiant apr�s covid [E20 � H21]
req3 <- "SELECT etudiant1, count(etudiant1) AS nb_liens FROM (
  SELECT DISTINCT etudiant1, etudiant2
    FROM collaborations WHERE session LIKE '%E20%' OR session LIKE '%A20%' OR session LIKE '%H21%')
GROUP BY etudiant1 ;"
Nbliens_ApCovid <- dbGetQuery(con, req3)
head(Nbliens_ApCovid)


#Requ�te des liens entre �tudiant apr�s covid (paires d'�tudiants uniques)
req4 <- "SELECT DISTINCT etudiant1, etudiant2
    FROM collaborations WHERE session LIKE '%A18%' OR session LIKE '%E20%' OR session LIKE '%A20%' OR session LIKE '%H21%'
GROUP BY etudiant1, etudiant2 ;"
liens_ApCovid <- dbGetQuery(con, req4)
head(liens_ApCovid)


#Requ�te du nombre de liens diff�rents par �tudiant par session 
req5 <- "SELECT etudiant1, count(etudiant1) AS nb_liens, session FROM (
  SELECT DISTINCT etudiant1, etudiant2, session
    FROM collaborations)
GROUP BY etudiant1, session ;"
Nbliens_se <- dbGetQuery(con, req5)
head(Nbliens_se)

