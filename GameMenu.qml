import QtMultimedia 5.0
import QtQuick 2.5

Rectangle {
	id: gameMenu
	
	property var menuSelectionColors: ['darkorange', 'darkgoldenrod', 'orangered']
	
	signal chosen(string value)
	
    width: parent.width * 0.6
    height: 300
	anchors.centerIn: parent
	
	color: 'aquamarine'
	border.color: 'aquamarine'
	border.width: 2
	
	
	ListModel {
		id: gameMenuModel
		ListElement {
            label: 'PARTIE RAPIDE';
			value: 'newgame';
		}
		ListElement {
            label: 'OPTIONS';
			value: 'options';
		}
		ListElement {
            label: 'QUITTER';
			value: 'quit';
		}
	}
	
	ListView {
		id: gameMenuList
		model: gameMenuModel
		width: gameMenu.width
		height: gameMenu.height
		focus: true
		delegate: Item {
			width: parent.width
			height: parent.height / 3
			Text {
				text: label
				color: 'maroon'
                font.pixelSize: 30
				font.family: 'Utopia'
				anchors.centerIn: parent
			}
		}
		highlightFollowsCurrentItem: false
		highlight: highlightManager
		highlightResizeDuration: 0
		
		Keys.onReturnPressed: gameMenu.chosen(gameMenuModel.get(gameMenuList.currentIndex).value);
	}
	Component {
	    id: highlightManager
	    Rectangle {
			id: currentHightlight
	        width: gameMenuList.width;
			height: gameMenuList.height / 3
			color: menuSelectionColors[gameMenuList.currentIndex]
			border.color: 'aquamarine'
			radius: 0
            onYChanged: menuSoundEffect.play()
	        y: gameMenuList.currentItem.y
	        Behavior on y {
				
	            ParallelAnimation {
					
					SequentialAnimation {
						NumberAnimation {
							target: currentHightlight
							property: 'border.width'
							duration: 150
							to: 10
							easing.type: Easing.InOutQuad
						}
						NumberAnimation {
							target: currentHightlight
							property: 'border.width'
							duration: 150
							to: 0
							easing.type: Easing.InOutQuad
						}
					}
					
					SequentialAnimation {
						NumberAnimation {
							target: currentHightlight
							property: 'radius'
							duration: 50
							to: 10
							easing.type: Easing.InOutQuad
						}
						NumberAnimation {
							target: currentHightlight
							property: 'radius'
							duration: 100
							to: 3
							easing.type: Easing.InOutQuad
						}
						NumberAnimation {
							target: currentHightlight
							property: 'radius'
							duration: 100
							to: 0
							easing.type: Easing.InOutQuad
						}
						
					}
					
	            }
				
	        }
	    }
		
	}
	
	SoundEffect {
        id: menuSoundEffect
        source: 'sounds/soundEffect_menuSel.wav'
    }

	function giveFocus() {
		gameMenuList.forceActiveFocus()
	}
	
}
