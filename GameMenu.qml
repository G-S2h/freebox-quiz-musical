import QtMultimedia 5.0
import QtQuick 2.5

Rectangle {
	id: gameMenu
	
	property var menuSelectionColors: ['darkorange', 'darkgoldenrod', 'orangered']
	property var menuSelectionSounds: ['soundEffect_kickDrum1.mp3', 'soundEffect_kickDrum2.wav', 'soundEffect_kickDrum3.wav']
	
	signal chosen(string value)
	
	width: parent.width / 2
	height: 300
	anchors.centerIn: parent
	
	color: 'aquamarine'
	border.color: 'aquamarine'
	border.width: 2
	
	
	ListModel {
		id: gameMenuModel
		ListElement {
			label: 'Partie rapide';
			value: 'newgame';
		}
		ListElement {
			label: 'Options';
			value: 'options';
		}
		ListElement {
			label: 'Quitter';
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
				font.pixelSize: 32
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
			onYChanged: soundEffect1.play()
	        y: gameMenuList.currentItem.y
	        Behavior on y {
				
	            ParallelAnimation {
					
					PropertyAnimation {
						target: soundEffect1
						property: 'play'
					}
					
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
		id: soundEffect1
		source: 'sounds/'+ menuSelectionSounds[0]
	}
	
	function giveFocus() {
		gameMenuList.forceActiveFocus()
	}
	
}
