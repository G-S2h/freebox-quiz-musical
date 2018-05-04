import QtQuick 2.5
import QtMultimedia 5.0

import fbx.application 1.0
import fbx.ui.control 1.0
import fbx.ui.page 1.0


Application {
	/* vars */
	property Component menuComponent: Qt.createComponent('GameMenu.qml');
	property Component gameComponent: Qt.createComponent('Game.qml');
	
	property Rectangle gameMenuObject;
	property Rectangle gameObject;
	property Rectangle gameOverObject;
	
	GameMenu { Component.onCompleted: destroy() }
	Game { Component.onCompleted: destroy() }
	GameOver { Component.onCompleted: destroy() }
	
	/* Background */
	Rectangle {
		anchors.fill: parent
		color: 'black'
	}
	
	/* Wrapper */
	Rectangle {
		id: wrapper
		width: parent.width - 25
		height: parent.height - 25
		anchors.centerIn: parent
		border.color: 'black'
		color: 'lightskyblue'
		radius: 10
		
		Component.onCompleted: { setMenu() }
		
	}
	
	
	function cb_menu(value) {
		switch(value) {
			case 'newgame':
				console.log('DEBUG. New game...');
				
				if(gameComponent.status == Component.Ready) {
					gameObject = gameComponent.createObject(wrapper);
					gameObject.giveFocus();
					gameObject.cancelGame.connect(cb_cancelGame);
					gameObject.gameOver.connect(cb_gameover);
				}
				else {
					console.log('Error. Could not load gameComponent (status:', gameComponent.status, ')):', gameComponent.errorString());
				}
				gameMenuObject.destroy();
			break;
			case 'options':
				console.log('DEBUG. Options...');
				
			break;
			case 'quit':
				console.log('DEBUG. Exiting application...')
				Qt.quit();
			break;
			default:
				console.log('Notice. Unknown menu entry value...');
		}
	}
	
	function cb_gameover(items) {
		gameObject.destroy();
		var component = Qt.createComponent('GameOver.qml');
		
		if(component.status == Component.Ready) {
			gameOverObject = component.createObject(wrapper);
			console.log(gameOverObject.setModelForGrid(items));
			gameOverObject.giveFocus();
			gameOverObject.toMenu.connect(cb_postGameOver)
			
		}
	}
	
	function cb_cancelGame() {
		gameObject.destroy();
		setMenu();
	}
	function cb_postGameOver() {
		gameOverObject.destroy();
		setMenu();
	}
	
	function setMenu() {
		console.log('DEBUG. Displaying menu...');
		if (menuComponent.status == Component.Ready) {
			gameMenuObject = menuComponent.createObject(wrapper);
			gameMenuObject.giveFocus();
			gameMenuObject.chosen.connect(cb_menu);
		}
		else {
			console.log('Error. Could not load menuComponnent (status: ', menuComponent.status, '): ', menuComponent.errorString(), ')');
		}
		
	}
	
}
