import QtMultimedia 5.0
import QtQuick 2.5

Rectangle {
	id: gameOver
	
	property var score: 0
	
	signal toMenu
	
	anchors.centerIn: parent
	width: parent.width * 0.75
	height: 300
	
	color: 'lightseagreen'
	
	ListView {
		id: playedSongsGrid
		focus: true
		header: Row {
				Text {
					text: 'Partie terminée\tScore : '+ score +'/10\nListe des chansons jouées'
					font.pixelSize: 16
				}
			}
		clip: true
		width: parent.width
		height: parent.height
		delegate: Row {
			
			width: parent.width
			
			Image { source: image }
			Column {
				Text { text: title }
				Text { text: artist }
			}
		}
		highlight: Rectangle { color: 'dodgerblue'; }
		
		Keys.onReturnPressed: {
			audioplayer.source = playedSongsGrid.model.get(playedSongsGrid.currentIndex).preview;
		}
		Keys.onBackPressed: { gameOver.toMenu() }
	}
	
	Audio {
		id: audioplayer
		autoPlay: true
	}
	
	function setModelForGrid(items) {
		playedSongsGrid.model = items;
	}
	
	function setScore(score) {
		gameOver.score = score;
	}
	
	function giveFocus() {
		playedSongsGrid.forceActiveFocus();
	}
}
