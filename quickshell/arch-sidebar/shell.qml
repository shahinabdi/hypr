
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "modules"

ShellRoot {
    id: root

    // Sidebar starts hidden and opens with SUPER + A.
    property bool sidebarVisible: false

    // =========================================
    // QUICK SETTINGS SIDEBAR
    // =========================================

    PanelWindow {
        id: sidebar

        visible: root.sidebarVisible

        anchors {
            right: true
            top: true
            bottom: true
        }

        margins {
            right: 12
            top: 12
            bottom: 12
        }

        implicitWidth: 360
        color: "transparent"

        Rectangle {
            anchors.fill: parent

            radius: 24
            color: "#1a1b26"

            border.width: 1
            border.color: "#414868"

            Flickable {
                anchors.fill: parent
                anchors.margins: 20

                contentWidth: width
                contentHeight: contentColumn.implicitHeight

                clip: true
                boundsBehavior: Flickable.StopAtBounds

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                Column {
                    id: contentColumn

                    width: parent.width
                    spacing: 18

                    // =================================
                    // HEADER
                    // =================================

                    Column {
                        width: parent.width
                        spacing: 5

                        Text {
                            text: "Quick Settings"
                            color: "#c0caf5"
                            font.pixelSize: 22
                            font.bold: true
                        }

                        Text {
                            text: "TOKYO NIGHT  •  ARCH LINUX"
                            color: "#565f89"
                            font.pixelSize: 10
                            font.letterSpacing: 1.5
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#414868"
                    }

                    // =================================
                    // CONNECTIVITY
                    // =================================

                    Text {
                        text: "CONNECTIVITY"
                        color: "#7aa2f7"
                        font.pixelSize: 11
                        font.bold: true
                        font.letterSpacing: 1.5
                    }

                    Wifi {
                        width: parent.width
                    }

                    BluetoothCard {
                        width: parent.width
                    }

                    // =================================
                    // AUDIO
                    // =================================

                    Text {
                        text: "AUDIO"
                        color: "#7aa2f7"
                        font.pixelSize: 11
                        font.bold: true
                        font.letterSpacing: 1.5
                    }

                    AudioCard {
                        width: parent.width
                    }

                    // =================================
                    // DISPLAY
                    // =================================

                    Text {
                        text: "DISPLAY"
                        color: "#7aa2f7"
                        font.pixelSize: 11
                        font.bold: true
                        font.letterSpacing: 1.5
                    }

                    BrightnessCard {
                        width: parent.width
                    }

                    // =================================
                    // FOOTER
                    // =================================

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#414868"
                    }

                    Text {
                        width: parent.width
                        text: "ARCH LINUX  •  HYPRLAND"
                        color: "#565f89"
                        font.pixelSize: 10
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }

    // =========================================
    // IPC COMMANDS
    // =========================================

    IpcHandler {
        target: "sidebar"

        function toggle(): void {
            root.sidebarVisible = !root.sidebarVisible
        }

        function open(): void {
            root.sidebarVisible = true
        }

        function close(): void {
            root.sidebarVisible = false
        }
    }
}

