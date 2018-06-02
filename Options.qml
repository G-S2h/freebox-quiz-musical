import QtQuick 2.5

import fbx.ui.control 1.0
import fbx.ui.settings 1.0

Rectangle {
	id: optionsContainer
	
	property var progressBarVisibility: true;
	property var progressBarPosition: 'above';
	
	width: parent.width * 0.75
	height: 200
	anchors.centerIn: parent
	
	Page {
		id: options
		showInfo: false
		Entry {
			anchors { left: parent.left; right: parent.right }
			text: 'Afficher le lecteur'
			info: 'Détermine l\'affichage du lecteur audio durant une partie.'
			Switch {
				checked: true
				onClicked: progressBarVisibility = checked;
			}
			
		}
		Entry {
			text: 'Position du lecteur'
			info: 'Détermine la position du lecteur audio durant une partie.'
			Combo {
			    items: ListModel {
					ListElement { label: 'Au-dessus'; value: 'above' }
					ListElement { label: 'Au centre'; value: 'center' }
					ListElement { label: 'En dessous'; value: 'below' }
			    }
				
			    onSelected: progressBarPosition = value;
			}
			
		}
		Entry {
			text: 'À propos'
			info: 'Quiz Musical est une application gratuite pour la Freebox.\n'+
				  'Toutes les chansons sont issues d\'iTunes, Apple, via le générateur de flux RSS.\n'+
				  'Les ressources (assets) proviennent de : bg.siteorigin.com ; cooltext.com ; freesound.org.\n'+
				  'Le code source de l\'application est disponible sur: \n'+
				  '\thttps://github.com/G-S2h/freebox-quiz-musical'
		}
	}
	
	Keys.onBackPressed: { optionsContainer.visible = false; setMenu(); }
	Keys.onEscapePressed: { optionsContainer.visible = false; setMenu(); }
	
	function giveFocus() {
		options.forceActiveFocus();
	}
}
	
	
	

