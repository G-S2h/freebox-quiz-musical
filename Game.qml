import QtQuick 2.5
import QtMultimedia 5.0
import QtQuick.XmlListModel 2.0

import fbx.ui.control 1.0

import 'JS/game.js' as GameJS

Rectangle {

	id: game
	width: parent.width
	height: parent.height
	color: 'transparent'
	
	Component.onCompleted: game.gameOver(undefined, undefined)
	property var progressBarPos: 'above';

	property variant currentSong;
	property int countGood: 0;
	property int countBad: 0;

	signal gameOver (ListModel items, var score)
	signal cancelGame

	/* vars */
	XmlListModel {
		id: songsModel
		source: 'http://itunes.apple.com/fr/rss/topsongs/limit=100/xml'
		query: '/feed/entry'

		namespaceDeclarations: 'declare default element namespace "http://www.w3.org/2005/Atom";'+
		'declare namespace im="http://itunes.apple.com/rss";'

		XmlRole { name: 'id'; query: 'id/@im:id/number()' }
		XmlRole { name: 'artist'; query: 'im:artist/string()' }
		XmlRole { name: 'title'; query: 'im:name/string()' }
		XmlRole { name: 'preview'; query: 'link[2]/@href/string()' }
		XmlRole { name: 'image'; query: 'im:image[2]/string()'}

		onStatusChanged: cb_loadingXml()
	}

	ListModel {
		id: currentSongsModel
	}
	
	ListModel {
		id: playedSongsModel
	}
	
	/* *** */
	
	Rectangle {
        id: gameProgress
        width: parent.width * 0.13
        height: 200
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 10
        }
        
        color: 'transparent'
        border.color: 'lightblue'
        border.width: 1
        
        Column {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            spacing: 10
            Repeater {
                id: gameBoardLeft
                model: 5
                Rectangle {
                    width: gameProgress.width * 0.4
                    height: gameProgress.height / 8
                    
                    color: 'transparent'
                    border.color: index == gameBoardLeft.model-1 ? 'gold' : 'gray'
                    
                    Text {
                        text: 5 - index
                        color: 'lightblue'
                        opacity: 0.5
                        anchors.centerIn: parent
                    }
                }
            }
        }
        Column {
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            spacing: 10
            Repeater {
                id: gameBoardRight
                model: 5
                Rectangle {
                    width: gameProgress.width * 0.4
                    height: gameProgress.height / 8
                    
                    color: 'transparent'
                    border.color: 'gray'
                    
                    Text {
                        text: 10 - index
                        color: 'lightblue'
                        opacity: 0.5
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
    
    Rectangle {
        id: gameProgressTime
        width: parent.width * 0.13
        height: 200
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 10
        }
        
        color: 'transparent'
        border.color: 'lightblue'
        border.width: 1
        
        property int counter: 30
        Text {
            id: gameProgressTimeText
            anchors {
                centerIn: parent
            }
            text: parent.counter
            font {
                pointSize: 32
                bold: true
            }
            color: 'lime'
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: updateGameProgressTime()
        }
    }
    
    Rectangle {
        id: gameBoard
        color: 'lightseagreen'
        width: parent.width * 0.7
        height: 210
        anchors.centerIn: parent
        GridView {
            id: currentSongsList
            model: currentSongsModel
            focus: true
            anchors.fill: parent
            
            cellWidth: (parent.width) / 2
            cellHeight: (parent.height) / 2
            delegate: Column {
                width: currentSongsList.cellWidth
                height: currentSongsList.cellheight
                
                Text {
                    text: '« '+ title +' »'
                    width: currentSongsList.cellWidth * 0.9
                    height: currentSongsList.cellHeight / 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    font { pixelSize: 22 }
                    elide: Text.ElideRight
                }
                Text {
                    text: artist
                    width: currentSongsList.cellWidth / 2
                    height: currentSongsList.cellHeight / 2
                    font { pixelSize: 20 }
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    elide: Text.ElideRight
                }
                
            }
            highlight: Rectangle { color: 'dodgerblue' }
            
            Keys.onBackPressed: {
                game.cancelGame();
            }
            Keys.onReturnPressed: checkSelectedSong()
        }
        
        ProgressBar {
            id: currSongProgressBar
            value: 0
            height: 24
            anchors {
                top: (progressBarPos == 'center' || progressBarPos == 'below' ? (progressBarPos == 'below' ?parent.bottom : parent.top) : undefined) ; centerIn: (progressBarPos == 'center' ? parent : undefined);
                bottom: (progressBarPos == 'above' ? parent.top : undefined)
                left: (progressBarPos == 'above' || progressBarPos == 'below' ? parent.left : undefined)
                right: (progressBarPos == 'above' || progressBarPos == 'below' ? parent.right : undefined)
            }
        }
    }
        
	Loading {
		id: loaderImage
		visible: false
		width: 64
		height: 64
		anchors.centerIn: parent
	}

	

	Timer {
		id: currSongTimer
		interval: 1000
		repeat: true
		running: false
		onTriggered: GameJS.updateProgressBar()
	}

	Audio {
		id: audioplayer
		autoPlay: true
		onPlaying: currSongTimer.running = true
	}
    
	function giveFocus() {
		currentSongsList.forceActiveFocus();
	}

	function setProgressBar(option_visibility) {
		if(!option_visibility)
			currSongProgressBar.height = 0;
	}
	/* *** *** *** */

	/**
	 *
	 */
	function cb_loadingXml() {

		switch(songsModel.status) {
			case XmlListModel.Loading:
				loaderImage.visible = true;
			break;
			case XmlListModel.Ready:
				loaderImage.visible = false;
				setCurrentSongs();
				playSong(currentSong);
			break;
			case XmlListModel.Error:
				console.log('Error. Could not load XML...');
			break;
		}
	}

	function playSong() {
		audioplayer.source = currentSong.preview;
	}
    
    function checkSelectedSong() {
        cb_testSong();
        if(playedSongsModel.count >= 10) {
            game.gameOver(playedSongsModel, countGood)
            //App.notifyUser('Partie terminée !')
        }
        else
            newRound();
    }
	/**
	 * Callback function when a song from currentSongsList is clicked
	 */
	function cb_testSong() {
		if(currentSongsModel.get(currentSongsList.currentIndex).id == currentSong.id) {
            //App.notifyUser('Bonne réponse !');
            updateGameBoard(countGood+countBad, true)
            countGood++;
		}
		else {
            //App.notifyUser('Mauvaise réponse...');
            updateGameBoard(countGood+countBad, false)
            countBad++;
		}
		
		setTimePause(500)
	}
    
    function updateGameBoard(questionCount, correct) {
        var color = correct ? 'forestgreen' : 'firebrick';
        
        if(questionCount < 5) {
            gameBoardLeft.itemAt(4 - questionCount).color = color
            gameBoardLeft.itemAt(4 - questionCount).border.color = color
        }
        else {
            gameBoardRight.itemAt(9 - questionCount).color = color
            gameBoardRight.itemAt(9 - questionCount).border.color = color
            
        }
        
        if(questionCount < 9) {
            if(questionCount < 4) {
                gameBoardLeft.itemAt(3 - questionCount).border.color = 'gold'
                gameBoardLeft.itemAt(3 - questionCount).opacity = 1
            }
            else {
                gameBoardRight.itemAt(8 - questionCount).border.color = 'gold'
                gameBoardLeft.itemAt(8 - questionCount).opacity = 1
            }
        }
    }
    
    function updateGameProgressTime() {
        gameProgressTime.counter -= 1;
        if(gameProgressTime.counter < 20)
            gameProgressTimeText.color = 'orangered';
        if(gameProgressTime.counter < 10)
            gameProgressTimeText.color = 'red';
        
        if(gameProgressTime.counter <= 0) {
            checkSelectedSong();
        }
    }
    
	/**
	 *
	 */
	function setCurrentSongs() {
		var totalSongsCount = songsModel.count;
		var randIndexes = [];
		var currIndex;
		if(totalSongsCount > 3) {
			do {
				currIndex = Math.floor( Math.random() * (totalSongsCount - 0) );
				if(randIndexes.indexOf(currIndex) == -1)
					randIndexes.push(currIndex);
			}while(randIndexes.length < 4);

			currentSongsModel.clear();
			for(var i=0;i<randIndexes.length;i++)
				currentSongsModel.append(songsModel.get(randIndexes[i]));

			currentSong = currentSongsModel.get( Math.floor( (Math.random()*(4 - 0)) ) );
			playedSongsModel.append(currentSong);
		}
	}

	function newRound() {
		setCurrentSongs();
		playSong();
		gameProgressTime.counter = 30;
	}
	
	function setTimePause(duration) {
		var timeStart = new Date().getTime();
		while (new Date().getTime() - timeStart < duration);
	}

}

