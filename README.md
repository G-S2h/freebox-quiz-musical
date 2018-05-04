# Quiz Musical pour Freebox
**Quiz Musical** est une application pour la Freebox Révolution où l'objectif est de deviner le titre de la chanson.<br />
Une partie se compose de dix chansons, et tous les extraits proviennent de [flux iTunes](https://rss.itunes.apple.com/fr-fr) : <br />
[http://itunes.apple.com/fr/rss/topsongs/limit=100/xml](http://itunes.apple.com/fr/rss/topsongs/limit=100/xml)

# Installation
Il est dans un premier temps nécessaire de télécharger le projet freebox-quiz-musical, ou bien de le cloner : <br />
`git clone https://github.com/G-S2h/freebox-quiz-musical.git`

## À l'aide de QtCreator et du plugin Freebox pour QtCreator
Après avoir suivi [la procédure d'installtion fournie par l'équipe Freebox](https://dev.freebox.fr/sdk/player.html). Il suffit de lancer _Qt Creator_, d'ouvrir le projet freebox-quiz-musical et de cliquer sur Exécuter après avoir pris soin de sélectionner la Freebox dans le panneau latéral gauche.<br />
L'application peut aussi être lancée sur le poste en local, mais il devient alors nécessaire de : 
- mettre en commentaire toutes les références à `App` dont les fonctions n'existent que dans le contexte de la Freebox. Deux lignes sont à commentées dans le fichier `Game.qml` : lignes 160 et 165 ;
- veiller à la bonne disponibilité d'un codex pour la lecture des fichiers audios.

## En ajoutant une nouvelle application sur le FreeFactory
Il suffit de se créer un compte sur le [FreeFactory](https://factory.free.fr/extranet/login.pl), de cliquer sur le bouton _Ajouter une nouvelle application..._ et de remplir les différents champs avant de soumettre l'archivre du projet freebox-quiz-musical.

