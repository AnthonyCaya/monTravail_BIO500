#Premier graphique, boxplot du nombre de liens par étudiant par session

#Transformer notre tableau du nombre de liens par étudiant par session en data frame 
Nbliens_se.df<- as.data.frame(Nbliens_se)

#Couper la colonne des noms d'étudiants de la table pour faciliter la création du boxplot
Nombre_liens_sans_nom <- data.frame(Nbliens_se.df$nb_liens,Nbliens_se.df$session)

#Faire le boxplot (moustache)
Nombre_liens_sans_nom$Nbliens_se.df.session <- factor(Nombre_liens_sans_nom$Nbliens_se.df.session,levels = c("H18","A18","H19","E19","A19","H20","E20","A20","H21"))
Graph_un<- boxplot(Nombre_liens_sans_nom$Nbliens_se.df.nb_liens~Nombre_liens_sans_nom$Nbliens_se.df.session, data =Nombre_liens_sans_nom,
            xlab = "Session", ylab = "Nombre de liens", main="Évolution du nombre de liens par étudiant par session",cex.main=1, cex.lab=1, cex.axis=1)

#--------------------------------------------------------------------------------
        
#Premier réseau de collaboration pré-covid
library(igraph)

#Créer matrice d'adjence
Matrice<- table(liens_AvCovid$etudiant1,liens_AvCovid$etudiant2)

#Créer le réseau
g<- graph.adjacency(Matrice)
plot(g,vertex.label = NA, edge.arrow.mode = 0,
     vertex.frame.color = NA)

#Changer la couleur des noeuds dans le réseau pré-covid

        #Calculer le degré de distance entre les étudiants
        deg<- apply(Matrice, 2, sum) + apply(Matrice, 1, sum)
        
        #Calculer le rang pour chaque noeud
        rk<- rank(deg)
        
        # Faire un code de couleur
        col.vec <-heat.colors(81)
        
        # Attribuer aux noeuds la couleur
        V(g)$color = col.vec[rk]
        # Refaire la figure en couleur
        plot(g, vertex.label=NA, edge.arrow.mode = 0,
             vertex.frame.color = NA)
        
#Changer la taille des noeuds du réseau
        
        # Faire un code de taille
        col.vec<-seq(10, 25, length.out =81 )
        
        # Attribuer aux noeuds la taille correspondante au rang
        V(g)$size = col.vec[rk]
        
        # Refaire la figure
        reseau_av <- plot(g, edge.arrow.mode = 0, vertex.label=NA)

#--------------------------------------------------------------------------------        

#Deusième réseau de collaboration post-covid
                
#Créer matrice d'adjence
Matrice.deux<- table(liens_ApCovid$etudiant1,liens_ApCovid$etudiant2)

#Créer le réseau
h<- graph.adjacency(Matrice.deux)
plot(h,vertex.label = NA, edge.arrow.mode = 0,
     vertex.frame.color = NA)

#Changer la couleur des noeuds dans le réseau pré-covid

        #Calculer le degré de distance entre les étudiants
        deg.deux<- apply(Matrice.deux, 2, sum) + apply(Matrice.deux, 1, sum)
        
        #Le rang pour chaque noeud
        rk.deux<- rank(deg.deux)
        
        # Faire un code de couleur
        col.vec.deux <-heat.colors(81)
        
        # Attribuer aux noeuds la couleur
        V(h)$color = col.vec.deux[rk.deux]
        
        # Refaire la figure en couleur
        plot(h, vertex.label=NA, edge.arrow.mode = 0,
             vertex.frame.color = NA)
        
#Changer la taille des noeuds
        
        # Faire un code de taille
        col.vec.deux<-seq(10, 25, length.out =81 )
        
        # Attribuer aux noeuds la taille correspondante au rang
        V(h)$size = col.vec.deux[rk.deux]
        
        # Refaire la figure
        reseau_ap <- plot(h, edge.arrow.mode = 0,vertex.label=NA)
           
#--------------------------------------------------------------------------------

#Tableau du nombre de liens avant et après la Covid

#Aller chercher les étudiants présent avant ET après la covid et les mettre
#dans un vecteur
Nom_Av_Ap <-c(Nbliens_AvCovid$etudiant1[Nbliens_AvCovid$etudiant1 %in% Nbliens_ApCovid$etudiant1])

#Tableau pré-covid
        #Sélectionner les étudiants (qui sont présent dans le vecteur) dans le tableau 
        #pré-Covid
        False<- c(Nbliens_AvCovid$etudiant1 %in% Nom_Av_Ap==T)
        
        #Combiner le vecteur de présence au tableau pré-covid
        Bruh<- cbind(Nbliens_AvCovid,False)
        
        #Créer un tableau de nombre de liens avec seulement les étudiants du vecteur
        Avant_tableau_Covid<- subset(Bruh,Bruh$False==TRUE)

#Tableau post-covid
        #Sélectionner les étudiants (qui sont présent dans le vecteur) dans le tableau 
        #post-Covid
        False.deux<- c(Nbliens_ApCovid$etudiant1 %in% Nom_Av_Ap==T)
        
        #Combiner le vecteur de présence au tableau post-covid
        Bruh.deux<- cbind(Nbliens_ApCovid,False.deux)
        
        #Créer un tableau de nombre de liens avec seulement les étudiants du vecteur
        Apres_tableau_Covid<- subset(Bruh.deux, Bruh.deux$False.deux==T)

#Sélection des colonnes de liens pré et post covid pour créer un tableau
#résumé pour les étudiants correspondants
Tableau_liens_Avant_Apres<- cbind(Avant_tableau_Covid$etudiant1,Avant_tableau_Covid$nb_liens,
                                  Apres_tableau_Covid$nb_liens)
Tableau_final<- as.data.frame(Tableau_liens_Avant_Apres)
Tableau_final$V4=(as.numeric(Tableau_final$V2)-as.numeric(Tableau_final$V3))

#Renommer les colonnes du tableau
colnames(Tableau_final)<- c("Nom","Pré-Covid","Post-Covid","Différence")


#------------------------------------------------------------------------------------------------------------------
#Enlever plusieurs Data pour permettre d'aérer l'environnement de travail (Étape à ne faire que si désiré)#
remove(Bruh,Bruh.deux,g,h,Nombre_liens_sans_nom,Tableau_liens_Avant_Apres)
#-----------------------------------------------------------------------------------------------------------------

        
#Calculer la moyenne de la différence du nombre de liens pré et post covid 
mean(Tableau_final$Différence)

