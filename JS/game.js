/**
 * 
 */
function updateProgressBar() {
	currSongProgressBar.value +=  ((audioplayer.position * 100) / audioplayer.duration) - currSongProgressBar.value;
	
}
