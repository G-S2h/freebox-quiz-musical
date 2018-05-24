import QtQuick 2.5
import QtMultimedia 5.0

import fbx.application 1.0
import fbx.ui.control 1.0
import fbx.ui.page 1.0


Application {
	/* vars */
	property Component menuComponent: Qt.createComponent('GameMenu.qml');
	property Component gameComponent: Qt.createComponent('Game.qml');
	property Component optionsComponent: Qt.createComponent('Options.qml');
	
	property Rectangle gameMenuObject;
	property Rectangle gameObject;
	property Rectangle optionsObject;
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
		
		Image {
			source: 'images/globalBg.png';
			fillMode: Image.Tile;
			anchors.fill: parent
		}
		
		Rectangle {
			id: tooltipBack
			anchors { bottom: parent.bottom; left: parent.left; leftMargin: 5 }
			height: 40
			Row {
				Column {
					Image {
						source: 'images/fbx_bt_retour.jpg'
					}
				}
				Column {
					Text {
						text: 'Menu'
						font.pixelSize: 20
						font.bold: true
						color: '#333'
						lineHeight: 22
					}
				}
			}
			
			
		}
		
		Component.onCompleted: { setMenu() }
		
	}
	
	
	function cb_menu(value) {
		switch(value) {
			case 'newgame':
				if(gameComponent.status == Component.Ready) {
					gameObject = gameComponent.createObject(wrapper, {progressBarPos: optionsObject ? optionsObject.progressBarPosition : 'above'});
					gameObject.giveFocus();
					
					if(optionsObject)
						gameObject.setProgressBar(optionsObject.progressBarVisibility);
					
					gameObject.cancelGame.connect(cb_cancelGame);
					gameObject.gameOver.connect(cb_gameover);
				}
				else {
					console.log('Error. Could not load gameComponent (status:', gameComponent.status, ')):', gameComponent.errorString());
				}
				tooltipBack.visible = true
				gameMenuObject.destroy();
			break;
			case 'options':
				
				if(optionsComponent.status == Component.Ready) {
					if(optionsObject)
						optionsObject.visible = true;
					else
						optionsObject = optionsComponent.createObject(wrapper);
					optionsObject.giveFocus()
				}
				else {
					console.log('Error. Could not load optionsComponent (status:', optionsComponent.status, ')):', optionsComponent.errorString());
				}
				tooltipBack.visible = true;
				gameMenuObject.destroy()
			break;
			case 'quit':
				Qt.quit();
			break;
			default:
				console.log('Notice. Unknown menu entry value...');
		}
	}
	
	function cb_gameover(items, score) {
		gameObject.visible = false;
		var component = Qt.createComponent('GameOver.qml');
		
		if(component.status == Component.Ready) {
			gameOverObject = component.createObject(wrapper);
			gameOverObject.setModelForGrid(items);
			gameOverObject.setScore(score)
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
		if (menuComponent.status == Component.Ready) {
			gameMenuObject = menuComponent.createObject(wrapper);
			gameMenuObject.giveFocus();
			gameMenuObject.chosen.connect(cb_menu);
		}
		else {
			console.log('Error. Could not load menuComponnent (status: ', menuComponent.status, '): ', menuComponent.errorString(), ')');
		}
		tooltipBack.visible = false
	}
	
}
