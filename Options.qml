import QtQuick 2.5

import fbx.ui.control 1.0
import fbx.ui.settings 1.0

Rectangle {
	id: optionsContainer
	
	property var option_1: false;
	property var option_2: false;
	
	width: parent.width * 0.75
	height: 200
	anchors.centerIn: parent
	
	Page {
		id: options
		showInfo: false
		Entry {
			anchors { left: parent.left; right: parent.right }
			text: "Switch"
			info: "Basic boolean value edition"
			Switch {
				checked: false
				onClicked: option_1 = checked;
			}
			
		}
		Entry {
			text: "Genre"
			info: "Le seul genre à utiliser pour le quiz"
			Combo {
			    items: ListModel {
					ListElement { label: "HDMI"; value: "AudioOutportHdmi" }
					ListElement { label: "SPDIF"; value: "AudioOutportSpdif" }
					ListElement { label: "Analogique"; value: "AudioOutportAnalog" }
			    }
				
			    onSelected: console.log("Selected index", index, "value", value);
			}
			
		}
	}
	
	Keys.onReturnPressed: { optionsoptionsContainer.visible = false; setMenu(); }
	Keys.onEscapePressed: { optionsContainer.visible = false; setMenu(); }
	
	function giveFocus() {
		options.forceActiveFocus();
	}
}
	
	
	

