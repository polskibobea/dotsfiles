{pkgs, inputs, ... }: {
      environment.systemPackages = [
      inputs.quickshell.packages.${pkgs.system}.default
    ];
  # hjem.users.bober.packages = [ pkgs.quickshell ];
  hjem.users.bober.files = {
    ".config/quickshell/mybar/shell.qml".text = ''
      import Quickshell
import Quickshell.Hyprland
import Quickshell.DBus
import QtQuick
import QtQuick.Layouts

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                bottom: true
            }

            width: 48
            color: "transparent"
            exclusiveZone: 48

            Rectangle {
                anchors.fill: parent
                color: "#cc0f0f14"
                border.color: "#22ffffff"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    spacing: 0

                    // ── Workspaces (góra) ───────────────────────────────────
                    Item {
                        id: workspacesWidget
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: 36
                        implicitHeight: workspacesCol.implicitHeight

                        property int activeId: HyprlandMonitor.activeWorkspace
                            ? HyprlandMonitor.activeWorkspace.id : 1

                        ColumnLayout {
                            id: workspacesCol
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 4

                            Repeater {
                                model: HyprlandWorkspace.workspaces

                                delegate: Rectangle {
                                    required property var modelData
                                    property bool isActive: modelData.id === workspacesWidget.activeId
                                    property bool hasWindows: modelData.windowCount > 0

                                    Layout.alignment: Qt.AlignHCenter
                                    width: 26
                                    height: 26
                                    radius: 6
                                    color: isActive ? "#b4befe" : (hasWindows ? "#45475a" : "#1e1e2e")
                                    border.color: isActive ? "#cdd6f4" : "#313244"
                                    border.width: 1

                                    Behavior on color { ColorAnimation { duration: 120 } }

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.id
                                        color: parent.isActive ? "#1e1e2e" : "#cdd6f4"
                                        font.pixelSize: 11
                                        font.family: "JetBrains Mono"
                                        font.weight: Font.Medium
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Hyprland.dispatch("workspace " + modelData.id)
                                    }

                                    // Dot — okna na workspace
                                    Rectangle {
                                        visible: parent.hasWindows && !parent.isActive
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.rightMargin: 3
                                        width: 4; height: 4; radius: 2
                                        color: "#89b4fa"
                                    }
                                }
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }

                    // ── Zegar + Data (środek) ───────────────────────────────
                    Item {
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: 48
                        implicitHeight: clockCol.implicitHeight

                        SystemClock {
                            id: clock
                            precision: SystemClock.Seconds
                        }

                        ColumnLayout {
                            id: clockCol
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 2

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: Qt.formatTime(clock.date, "HH")
                                color: "#cdd6f4"
                                font.pixelSize: 15
                                font.family: "JetBrains Mono"
                                font.weight: Font.Bold
                                font.letterSpacing: 1
                            }

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                width: 20; height: 1
                                color: "#313244"
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: Qt.formatTime(clock.date, "mm")
                                color: "#cdd6f4"
                                font.pixelSize: 15
                                font.family: "JetBrains Mono"
                                font.weight: Font.Bold
                                font.letterSpacing: 1
                            }

                            Item { implicitHeight: 4 }

                            // Data pionowo
                            Repeater {
                                model: Qt.formatDate(clock.date, "dd/MM/yy").split("")

                                delegate: Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: modelData
                                    color: "#6c7086"
                                    font.pixelSize: 9
                                    font.family: "JetBrains Mono"
                                    font.letterSpacing: 0.5
                                }
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }

                    // ── Bateria + WiFi + Bluetooth (dół) ────────────────────
                    ColumnLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 6

                        // Battery
                        Item {
                            Layout.alignment: Qt.AlignHCenter
                            implicitWidth: 36
                            implicitHeight: 36

                            DbusServiceProxy {
                                id: upower
                                service: "org.freedesktop.UPower"
                                path: "/org/freedesktop/UPower/devices/DisplayDevice"
                                interface: "org.freedesktop.UPower.Device"
                                property double percentage: 100
                                property int state: 0
                                onConnected: {
                                    percentage = getProperty("Percentage") || 100
                                    state = getProperty("State") || 0
                                }
                            }

                            property double pct: upower.percentage
                            property bool charging: upower.state === 1
                            property bool full: upower.state === 4

                            property string battIcon: {
                                if (charging || full) return "󰂄"
                                if (pct > 90) return "󰁹"
                                if (pct > 75) return "󰂀"
                                if (pct > 50) return "󰁾"
                                if (pct > 30) return "󰁼"
                                if (pct > 15) return "󰁺"
                                return "󰂃"
                            }
                            property string battColor: {
                                if (charging) return "#a6e3a1"
                                if (pct <= 15) return "#f38ba8"
                                if (pct <= 30) return "#fab387"
                                return "#cdd6f4"
                            }

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 1

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: parent.parent.battIcon
                                    color: parent.parent.battColor
                                    font.pixelSize: 16
                                    font.family: "JetBrainsMono Nerd Font"
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: Math.round(parent.parent.pct) + "%"
                                    color: parent.parent.battColor
                                    font.pixelSize: 8
                                    font.family: "JetBrains Mono"
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }
                            }
                        }

                        // WiFi
                        Item {
                            Layout.alignment: Qt.AlignHCenter
                            implicitWidth: 36
                            implicitHeight: 36

                            DbusServiceProxy {
                                id: nm
                                service: "org.freedesktop.NetworkManager"
                                path: "/org/freedesktop/NetworkManager"
                                interface: "org.freedesktop.NetworkManager"
                                property int connectivity: 1
                                property bool wifiEnabled: false
                                onConnected: {
                                    connectivity = getProperty("Connectivity") || 1
                                    wifiEnabled = getProperty("WirelessEnabled") || false
                                }
                            }

                            property bool wifiConnected: nm.connectivity === 4
                            property bool wifiLimited: nm.connectivity === 3

                            property string wifiIcon: {
                                if (!nm.wifiEnabled) return "󰖪"
                                if (wifiConnected) return "󰖩"
                                if (wifiLimited) return "󰤮"
                                return "󰖪"
                            }
                            property string wifiColor: {
                                if (wifiConnected) return "#89b4fa"
                                if (wifiLimited) return "#fab387"
                                return "#6c7086"
                            }

                            Rectangle {
                                anchors.fill: parent
                                color: wifiMa.containsMouse ? "#313244" : "transparent"
                                radius: 8
                                Behavior on color { ColorAnimation { duration: 100 } }

                                Text {
                                    anchors.centerIn: parent
                                    text: parent.parent.wifiIcon
                                    color: parent.parent.wifiColor
                                    font.pixelSize: 18
                                    font.family: "JetBrainsMono Nerd Font"
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                MouseArea {
                                    id: wifiMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Quickshell.exec("nm-connection-editor")
                                }
                            }

                            // Tooltip → prawa strona
                            Rectangle {
                                visible: wifiMa.containsMouse
                                anchors.left: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 6
                                color: "#181825"
                                border.color: "#313244"
                                border.width: 1
                                radius: 6
                                width: wifiTip.implicitWidth + 12
                                height: 22
                                z: 100

                                Text {
                                    id: wifiTip
                                    anchors.centerIn: parent
                                    text: parent.parent.wifiConnected
                                        ? "WiFi połączony"
                                        : (parent.parent.wifiLimited ? "Ograniczony" : "Brak połączenia")
                                    color: "#cdd6f4"
                                    font.pixelSize: 10
                                    font.family: "JetBrains Mono"
                                }
                            }
                        }

                        // Bluetooth
                        Item {
                            Layout.alignment: Qt.AlignHCenter
                            implicitWidth: 36
                            implicitHeight: 36

                            DbusServiceProxy {
                                id: bluez
                                service: "org.bluez"
                                path: "/org/bluez/hci0"
                                interface: "org.bluez.Adapter1"
                                property bool powered: false
                                onConnected: {
                                    powered = getProperty("Powered") || false
                                }
                            }

                            DbusServiceProxy {
                                id: bluezMgr
                                service: "org.bluez"
                                path: "/"
                                interface: "org.freedesktop.DBus.ObjectManager"
                                property bool anyConnected: false
                            }

                            property bool btOn: bluez.powered
                            property bool btConn: bluezMgr.anyConnected

                            property string btIcon: {
                                if (!btOn) return "󰂲"
                                if (btConn) return "󰂱"
                                return "󰂯"
                            }
                            property string btColor: {
                                if (!btOn) return "#6c7086"
                                if (btConn) return "#cba6f7"
                                return "#89b4fa"
                            }

                            Rectangle {
                                anchors.fill: parent
                                color: btMa.containsMouse ? "#313244" : "transparent"
                                radius: 8
                                Behavior on color { ColorAnimation { duration: 100 } }

                                Text {
                                    anchors.centerIn: parent
                                    text: parent.parent.btIcon
                                    color: parent.parent.btColor
                                    font.pixelSize: 18
                                    font.family: "JetBrainsMono Nerd Font"
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                MouseArea {
                                    id: btMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Quickshell.exec("blueman-manager")
                                }
                            }

                            // Tooltip → prawa strona
                            Rectangle {
                                visible: btMa.containsMouse
                                anchors.left: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 6
                                color: "#181825"
                                border.color: "#313244"
                                border.width: 1
                                radius: 6
                                width: btTip.implicitWidth + 12
                                height: 22
                                z: 100

                                Text {
                                    id: btTip
                                    anchors.centerIn: parent
                                    text: parent.parent.btConn
                                        ? "BT połączony"
                                        : (parent.parent.btOn ? "BT włączony" : "BT wyłączony")
                                    color: "#cdd6f4"
                                    font.pixelSize: 10
                                    font.family: "JetBrains Mono"
                                }
                            }
                        }

                    } // ColumnLayout bottom
                } // ColumnLayout main
            } // Rectangle bg
        } // PanelWindow
    } // Variants
} // ShellRoot
         '';
  };
}

