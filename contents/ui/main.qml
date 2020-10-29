/*
    SPDX-FileCopyrightText: 2020 AERegeneratel38 <mukunda.adhikari@outlook.com>
    SPDX-License-Identifier: LGPL-2.1-or-later
*/

import QtQuick 2.12
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.aestheticclock 1.0


Item {
   Plasmoid.fullRepresentation: Item {
      
        Layout.minimumWidth : plasmoid.formFactor == PlasmaCore.Types.Horizontal ? height : 350 
        Layout.minimumHeight : plasmoid.formFactor == PlasmaCore.Types.Vertical ? width  : 380
        Layout.preferredWidth:  350* units.devicePixelRatio
        Layout.preferredHeight: 380 * units.devicePixelRatio
        Plasmoid.backgroundHints: "NoBackground";
        
        
        Rectangle {
        id: gradientrect
        anchors.fill: parent
        radius: 15
        gradient: Gradient {
        GradientStop { position: 1.0; color: "#FF512F" }
        GradientStop { position: 0.0; color: "#F09819" }
        
    }
    
        Image {
            source: "1.png"
            anchors.fill: gradientrect 
            fillMode: Image.PreserveAspectCrop
            anchors.bottom: gradientrect.bottom
            opacity: 0.05
        }
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        
        Label {
        text: Qt.formatDate(timeSource.data["Local"]["DateTime"],"dddd" ) + ", " + Qt.formatDate(timeSource.data["Local"]["DateTime"], "MMMM dd" )
        color: "#FFFFFF"
       
        font.family: "Noto Sans" 
        font.pixelSize: 16
        font.weight: Font.ExtraBold
        Layout.alignment: Qt.AlignHCenter
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 15
            
        }
    }
    
    
        Label {
        text: hours + ":" + ('0'+ minutes).slice(-2);
        color: "#FFFFFF"
       
        font { family: "Noto Sans"; pixelSize: 60}
        Layout.alignment: Qt.AlignHCenter
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            
        }
        }
            
    }
    property int hours
    property int minutes
    property int minute
    
    function timeChanged() {
        var date = new Date;
        hours = date.getHours();
       if (hours > 12) {
           hours = hours - 12
    }
        minutes = date.getMinutes();
        minute = date.getMinutes();
    }
    
    Canvas {
        id:canvas
        anchors.fill: gradientrect
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

            var centreX = width / 2;
            var centreY = height / 2;

            ctx.beginPath();
            ctx.arc(centreX, centreY, width / 3, -Math.PI/2, (3 * Math.PI)/2);
            ctx.lineWidth = 10;
            ctx.strokeStyle = "rgba(255,255,255,0.4)"
            ctx.stroke();
            
            ctx.beginPath();
            ctx.arc((centreX + ((width / 3) * Math.cos((((hours*30)*(Math.PI/180)) - 1.57)))),( centreY + ((width / 3) * Math.sin((((hours*30)*(Math.PI/180)) - 1.57)))), 9, -Math.PI, Math.PI );
            ctx.fillStyle = "white";
            ctx.fill();
           
            ctx.beginPath();
            ctx.arc((centreX + ((width / 3) * Math.cos((((minute*6)*(Math.PI/180)) - 1.57)))),( centreY + ((width / 3) * Math.sin((((minute*6)*(Math.PI/180)) - 1.57)))), 9, -Math.PI, Math.PI );
            ctx.fillStyle = "white";
            ctx.fill();

            
        }
    }
   
    
    PlasmaCore.DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }
    
    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: { 
            canvas.requestPaint()
            timeChanged()
            
        }
    }

       
       
       
       
       
       
    }
}
