import QtQuick 2.5

Rectangle {
	id: gameMenu
	
	signal chosen(string value)
	
	width: parent.width / 2
	height: 300
	anchors.centerIn: parent
	
	color: 'aquamarine'
	border.color: 'lightgrey'
	
	
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
				color: 'black'
				font.pixelSize: 32
				anchors.centerIn: parent
			}
		}
		highlight: Rectangle {
			color: 'darkcyan'
		}
		highlightResizeDuration: 0 // Disable growing width animation
		
		Keys.onReturnPressed: gameMenu.chosen(gameMenuModel.get(gameMenuList.currentIndex).value);
	}
	
	function giveFocus() {
		gameMenuList.forceActiveFocus()
	}
	
}
