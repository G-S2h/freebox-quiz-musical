import QtQuick 2.5
import QtMultimedia 5.0
import QtQuick.XmlListModel 2.0

import fbx.ui.control 1.0

import 'JS/game.js' as GameJS

Rectangle {
	id: game
	width: parent.width * 0.75
	height: 200
	anchors.centerIn: parent
	color: 'lightseagreen'
	
	property var progressBarPos: 'below';
	
	signal gameOver (ListModel items)
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
	
	property variant currentSong;
	property int countGood: 0;
	property int countBad: 0;
	
	/* *** */
	
	GridView {
		id: currentSongsList
		model: currentSongsModel
		focus: true
		
		width: parent.width
		height: parent.height
		cellWidth: (parent.width) / 2
		cellHeight: (parent.height) / 2
		delegate: Column {
			width: currentSongsList.cellWidth 
			height: currentSongsList.cellheight
			
			Text {
				text: title
				width: currentSongsList.cellWidth / 2
				anchors.horizontalCenter: parent.horizontalCenter
				font { pixelSize: 22; italic: true }
				elide: Text.ElideRight
				//wrapMode: Text.wordWrap;
			}
			Text {
				text: artist
				width: currentSongsList.cellWidth / 2
				font { pixelSize: 20 }
				anchors.horizontalCenter: parent.horizontalCenter
				elide: Text.ElideRight
				//wrapMode: Text.wordWrap;
			}
			
		}
		highlight: Rectangle { color: 'dodgerblue' }
		
		Keys.onBackPressed: {
			game.cancelGame();
		}
		Keys.onReturnPressed: {
			cb_testSong();
			if(playedSongsModel.count >= 10)
				game.gameOver(playedSongsModel)	
			else
				newRound();
		}
		
	}
	
	Loading {
		id: loaderImage
		visible: false
		width: 64
		height: 64
		anchors.centerIn: parent
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
		//anchors {top: parent.top; centerIn: parent} // Centered in
		//anchors { bottom: parent.top; right: parent.right; left: parent.left} // Over board
		//anchors { top: parent.bottom; right: parent.right; left: parent.left} // Under board
		
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
	
	Text {
		id: scoreText
		text: 'Score: '+ countGood +'/'+ countBad
		font.pixelSize: 22
		anchors { bottom: parent.bottom; right: parent.right }
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
	
	/**
	 * Callback function when a song from currentSongsList is clicked
	 */
	function cb_testSong() {
		if(currentSongsModel.get(currentSongsList.currentIndex).id == currentSong.id) {
			//App.notifyUser('Bien !');
			countGood++;
		}
		else {
			//App.notifyUser('Nul !');
			countBad++;
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
	}
	
}
