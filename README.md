# Modele_de_trajectoires_systeme_solaire

Ce modèle a pour but de simuler le système solaire et de venir générer des trajectoires par le modèle génétique.
Le modèle s'inscrit dans le cadre du projet scolaire sur la conception d'un "module de transport adaptable pour trajets réguliers Terre-Mars"



Organisation du code
-----------------------------------------------------------------------------------------------
Description du fonctionnement du code

Modele_Trajectoire_Projet4A.m est le fichier principal, il lance les fichiers simulink contenant le système solaire avec les paramètres initiaux. A chaque simulation il recupère les paramètres finaux comme la meilleure distance d'arrivée. Et utilise l’algorithme génétique pour créer de nouveaux paramètres initiaux pour les prochaines simulations.

SIMU_systeme_solaire.slx et SIMU_trajectoire_vaisseau.slx sont les fichiers simulink utile aux simulations du trajet Terre-Mars et Mars-Terre

Visualisation_trajectoire.m est un fichier matlab qui permet de visualiser une trajectoire sauvgardé



Pour aller plus loin
-----------------------------------------------------------------------------------------------

Idées intéressantes a developper :

  []Un système solaire complet <br />
  []La prise en compte de la poussée continue <br />
  []Réfléchir sur l’orientation et déclenchement de cette poussée <br />
  []Quaternion <br />
  []Départs et arrivée <br />
  []Affichage de plusieurs moniteurs <br />
  []Big data avec de nombreuses trajectoires <br />


Idée réaliste faisable :

  []Un système solaire complet <br />
  []Départs et arrivée <br />
  []Big data avec de nombreuses trajectoires, analyse avec Tableau <br />
  
