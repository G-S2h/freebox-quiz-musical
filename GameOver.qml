import QtMultimedia 5.0
import QtQuick 2.5

Rectangle {
	id: gameOver
	
	property var score: 0
	
	signal toMenu
	
	anchors.centerIn: parent
	width: parent.width * 0.75
	height: 490
	
	color: 'lightseagreen'
    
    Rectangle {
        anchors {
            bottom: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        
        Text {
            anchors {
                bottom: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            text: 'Partie Terminée'
            color: 'white'
            font.family: 'Helvetica'
            font.pixelSize: 28
            font.bold: true
            font.capitalization: Font.SmallCaps
        }
    }

	GridView {
		id: playedSongsGrid
		focus: true
		header: Row {
				height: 32
				Text {
					text: 'Liste des chansons jouées'
					color: 'white'
					font.bold: true
					font.pixelSize: 16
					font.capitalization: Font.SmallCaps
					width: gameOver.width / 2
                }
                Text {
                    text: 'Score : '+ score +'/10'
                    color: 'white'
					font.bold: true
					font.pixelSize: 16
					font.capitalization: Font.SmallCaps
					width: gameOver.width / 2 - 64
                    horizontalAlignment: Text.AlignRight
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
