import QtMultimedia 5.0
import QtQuick 2.5

Rectangle {
	id: gameOver
	
	property var score: 0
	
	signal toMenu
	
	anchors.centerIn: parent
	width: parent.width * 0.75
	height: 500
	
	color: 'lightseagreen'
	
	GridView {
		id: playedSongsGrid
		focus: true
		header: Row {
				Text {
					text: 'Partie terminée\t\tScore: '+ score +'/10\nListe des chansons jouées :'
					font.pixelSize: 16
                }
			}
		
		width: parent.width < 900 ? parent.width : 900
		height: parent.height
		anchors.horizontalCenter: parent.horizontalCenter
		
		cellWidth: 180
		cellHeight: 220
		clip: true
		delegate: Column {
            width: parent.cellWidth - 10
            height: parent.cellHeight
            
            Column {
                Text {
                    text: '3 secondes'
                }
            }
			Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: imageBig
			}
			Column {
				Text {
                    width: playedSongsGrid.cellWidth * 0.9
                    text: '« '+ title +' »'
                    elide: Text.ElideRight
				}
				Text {
                    width: playedSongsGrid.cellWidth * 0.9
                    text: artist
                    elide: Text.ElideRight
				}
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
