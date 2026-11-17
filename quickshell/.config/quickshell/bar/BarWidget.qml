import QtQuick
import "../services"

// A bar item that expands the bar into a panel.
//  - hover -> `hoverContent` (falls back to `panelContent`)
//  - click -> pins `panelContent` (unless pinOnClick is false; right click always pins)
//    and emits clicked() for left clicks
// Children declared inside are the visible bar content.
Item {
    id: root

    property string name: ""
    property Component hoverContent
    property Component panelContent
    property bool pinOnClick: true
    signal scrolled(int delta)
    signal clicked

    default property alias data: holder.data

    implicitWidth: holder.children.length ? holder.children[0].implicitWidth : 0
    implicitHeight: holder.children.length ? holder.children[0].implicitHeight : 0

    Item {
        id: holder
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: PopupState.enter(root)
        onExited: PopupState.leave()
        onWheel: wheel => root.scrolled(wheel.angleDelta.y)
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
                root.clicked();
            if (root.panelContent && (root.pinOnClick || mouse.button === Qt.RightButton))
                PopupState.pinned = PopupState.pinned === root ? null : root;
        }
    }
}
