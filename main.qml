import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt.labs.platform

ApplicationWindow {
    id: mainWindow
    width: 900
    height: 800
    visible: true
    title: "Terra Quantum Optimization"

    property int dimensions: 0
    property double lowerBound: 0.0
    property double upperBound: 0.0
    property double gridSizeFactorP: 0.0
    property double gridSizeFactorQ: 0.0
    property int evals: 0
    property int funcIndex: 0
    property bool isFuncChecked: false
    property bool isVectChecked: false
    property bool withCache: false
    property bool withLog: false
    property bool withOpt: false

    FileDialog {
        id: saveFileDialog
        title: "Save downloaded_solution.txt"
        acceptLabel: "Save"
        rejectLabel: "Cancel"
        nameFilters: ["Text Files (*.txt)", "All Files (*)"]
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        onAccepted: {
            console.log("Save accepted")
            cppInterface.saveSolution(file)
        }
        onRejected: {
            console.log("Save rejected")
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#0e0b0b"
        ScrollView {
            anchors.fill: parent

            Label {
                id: titleBar
                width: parent.width
                height: 30
                anchors.top: parent.top
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "Terra Quantum Optimization Tool"
                font.pixelSize: 24
                font.bold: true
                color: "#ffffff"
            }

            Row {
                id:onlineOfflineBar
                height: 30
                anchors.top: titleBar.bottom
                anchors.topMargin: 30
                spacing: 20
                Switch {
                    id: onlineOfflineSwitch
                    checked: true
                    onStateChanged: {
                        console.log("onStateChanged: "+checked);

                    }
                    background: Rectangle {
                        implicitWidth: 40
                        implicitHeight: 20
                        radius: 10
                        color: onlineOfflineSwitch.checked ? "green" : "white"
                    }
                }
                Label {
                    id: onlineOfflineLabel
                    text: (onlineOfflineSwitch.checked)?
                              "Online : Straight from the cloud":
                              "Offline: Make sure tq-backend is available at http://localhost:5000"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#ffffff"
                }
            }

            Row {
                id: funcTitleBar
                height: 30
                width: parent.width
                anchors.top: onlineOfflineBar.bottom
                anchors.topMargin: 30
                spacing: 20
                Label {
                    id:funcTitleLabel
                    width:120
                    horizontalAlignment: Text.AlignRight
                    text: "Function:"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#ffffff"
                }
                ComboBox {
                    id: dispFuncName
                    width: 150
                    model: ["Simple", "Tensor", "Alpine"]
                    currentIndex: 0 // Default to "Simple"
                    onCurrentIndexChanged: {
                        console.log("onCurrentIndexChanged: "+currentIndex);
                        functionInfo.text = parent.getFunctionInfo(currentIndex)
                    }
                }
                Label {
                    id: functionInfo
                    text: parent.getFunctionInfo(dispFuncName.currentIndex)
                    font.pixelSize: 16
                    font.bold: true
                    color: "#ffffff"
                }
                function getFunctionInfo(functionNameIndex) {
                    switch (functionNameIndex) {
                    case 0:// "Simple"
                        return "f(x) = sum(abs(x * sin(x) + 0.1 * x)), x in [-10, 10]";
                    case 1:// "Tensor"
                        return "f(x) = sin(0.1 * x[0])**2 + 0.1 * sum(x[1:]**2), x in [-1, 1]";
                    case 2:// "Alpine"
                        return "f(i) = (i[0] - 2)**2 + (i[1] - 3)**2 + sum(i[2:]**4), i in [0, 1, 2, 3]";
                    default:// "Simple"
                        return "f(x) = sum(abs(x * sin(x) + 0.1 * x)), x in [-10, 10]";
                    }
                }
            }

            Row {
                id: inputOutputRow
                anchors.top: funcTitleBar.bottom
                anchors.topMargin: 20
                height: 350
                width: parent.width
                Column {
                    width: 2 * parent.width / 3
                    spacing: 20
                    Row {
                        spacing: 20
                        Label {
                            text: "Dimensions (d):"
                            width:200
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                        Slider {
                            id: dimensionsInput
                            width: 300
                            from: 1
                            to: 100
                            value: 10
                            stepSize: 1
                            onValueChanged: {
                                console.log("onValueChanged: "+value);
                                dimensionsLabel.text = value.toString()
                            }
                        }
                        Label {
                            id: dimensionsLabel
                            text: dimensionsInput.value.toString()
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                    }
                    Row {
                        spacing: 20
                        Label {
                            text: "Grid Lower Bound (a):"
                            width:200
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                        Slider {
                            id: lowerBoundInput
                            width: 300
                            from: -10.0
                            to: 10.0
                            value: -1.0
                            stepSize: 0.1
                            onValueChanged: lowerBoundLabel.text = value.toString()
                        }
                        Label {
                            id: lowerBoundLabel
                            text: lowerBoundInput.value.toString()
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                    }
                    Row {
                        spacing: 20
                        Label {
                            text: "Grid Upper Bound (b):"
                            width:200
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                        Slider {
                            id: upperBoundInput
                            width: 300
                            from: -10.0
                            to: 10.0
                            value: 1.0
                            stepSize: 0.1
                            onValueChanged: upperBoundLabel.text = value.toString()
                        }
                        Label {
                            id: upperBoundLabel
                            text: upperBoundInput.value.toString()
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                    }
                    Row {
                        spacing: 20
                        Label {
                            text: "Grid Size Factor (p):"
                            width:200
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                        Slider {
                            id: gridSizeFactorInputP
                            width: 300
                            from: 1
                            to: 20
                            value: 4
                            stepSize: 1
                            onValueChanged: gridSizeFactorLabelP.text = value.toString()
                        }
                        Label {
                            id: gridSizeFactorLabelP
                            text: gridSizeFactorInputP.value.toString()
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                    }
                    Row {
                        spacing: 20
                        Label {
                            text: "Grid Size Factor (q):"
                            width:200
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                        Slider {
                            id: gridSizeFactorInputQ
                            width: 300
                            from: 1
                            to: 20
                            value: 4
                            stepSize: 1
                            onValueChanged: gridSizeFactorLabelQ.text = value.toString()
                        }
                        Label {
                            id: gridSizeFactorLabelQ
                            text: gridSizeFactorInputQ.value.toString()
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                    }
                    Row {
                        spacing: 20
                        Label {
                            text: "Number of Evals:"
                            width:200
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                        SpinBox {
                            id: evalsInput
                            width: 150
                            from: 1
                            to: 100000
                            value: 100000
                        }
                    }
                    Row {
                        spacing: 20
                        Row {
                            Label {
                                text: "is_func:"
                                width:80
                                horizontalAlignment: Text.AlignRight
                                font.pixelSize: 16
                                font.bold: true
                                color: "#ffffff"
                            }
                            CheckBox {
                                id: isFuncCheck
                                checked: true
                            }
                        }
                        Row {
                            Label {
                                text: "is_vect:"
                                width:80
                                horizontalAlignment: Text.AlignRight
                                font.pixelSize: 16
                                font.bold: true
                                color: "#ffffff"
                            }
                            CheckBox {
                                id: isVectCheck
                                checked: true
                            }
                        }
                        Row {
                            Label {
                                text: "with_cache:"
                                width:100
                                horizontalAlignment: Text.AlignRight
                                font.pixelSize: 16
                                font.bold: true
                                color: "#ffffff"
                            }
                            CheckBox {
                                id: withCacheCheck
                                checked: false
                            }
                        }
                    }
                    Row {
                        spacing: 20
                        Row {
                            Label {
                                text: "with_log:"
                                width:80
                                horizontalAlignment: Text.AlignRight
                                font.pixelSize: 16
                                font.bold: true
                                color: "#ffffff"
                            }
                            CheckBox {
                                id: withLogCheck
                                checked: true
                            }
                        }
                        Row {
                            Label {
                                text: "with_opt:"
                                width:80
                                horizontalAlignment: Text.AlignRight
                                font.pixelSize: 16
                                font.bold: false
                                color: "#ffffff"
                            }
                            CheckBox {
                                id: withOptCheck
                                checked: false
                            }
                        }
                    }
                    Row {
                        spacing: 10
                        Button {
                            width: 200
                            text: "Run Optimization"
                            onClicked: {
                                console.log("Button clicked: Run Optimization");
                                solverStatus.text = "Processing..."
                                logsTextArea.text = ""
                                functionNameOutput.text = ""
                                evalsOutput.text = ""
                                tOutput.text =""
                                exOutput.text = ""
                                eyOutput.text = ""
                                downloadStatusLabel.text = ""
                                // Save the settings for future recalucation request
                                saveSettings()
                                // Send data to the C++ backend for processing
                                cppInterface.runOptimization(
                                            dimensionsInput.value,
                                            lowerBoundInput.value,
                                            upperBoundInput.value,
                                            gridSizeFactorInputP.value,
                                            gridSizeFactorInputQ.value,
                                            evalsInput.value,
                                            dispFuncName.currentText,
                                            isFuncCheck.checked,
                                            isVectCheck.checked,
                                            withCacheCheck.checked,
                                            withLogCheck.checked,
                                            withOptCheck.checked
                                            )
                            }
                        }
                    }
                }

                Column {
                    width: parent.width / 3
                    height: 300
                    spacing: 20
                    Row {
                        spacing: 20
                        Label {
                            text: "Solver Status: "
                            width: 100
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                        Label {
                            id: solverStatus
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                    }
                    Row {
                        spacing: 20
                        Label {
                            text: "Function Name: "
                            width: 100
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                        Label {
                            id: functionNameOutput
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                    }
                    Row {
                        spacing: 20
                        Label {
                            text: "Evals: "
                            width: 100
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                        Label {
                            id: evalsOutput
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                    }
                    Row {
                        spacing: 20
                        Label {
                            text: "t_all or t_cur: "
                            width: 100
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                        Label {
                            id: tOutput
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                    }
                    Row {
                        spacing: 20
                        Label {
                            text: "e_x: "
                            width: 100
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                        Label {
                            id: exOutput
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                    }
                    Row {
                        spacing: 20
                        Label {
                            text: "e_y: "
                            width: 100
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                        Label {
                            id: eyOutput
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                    }
                    Row {
                        spacing: 20
                        Button {
                            text: "Recalculate"
                            onClicked: {
                                console.log("Button clicked: Run Optimization");
                                solverStatus.text = "Processing..."
                                logsTextArea.text = ""
                                functionNameOutput.text = ""
                                evalsOutput.text = ""
                                tOutput.text =""
                                exOutput.text = ""
                                eyOutput.text = ""
                                downloadStatusLabel.text = ""
                                // load the settings for recalucation request
                                dimensionsInput.value = mainWindow.dimensions
                                lowerBoundInput.value = mainWindow.lowerBound
                                upperBoundInput.value = mainWindow.upperBound
                                gridSizeFactorInputP.value = mainWindow.gridSizeFactorP
                                gridSizeFactorInputQ.value = mainWindow.gridSizeFactorQ
                                evalsInput.value = mainWindow.evals
                                dispFuncName.currentIndex = mainWindow.funcIndex
                                isFuncCheck.checked = isFuncChecked
                                isVectCheck.checked = isVectChecked
                                withCacheCheck.checked = withCache
                                withLogCheck.checked = true
                                withOptCheck.checked = withOpt
                                // Send data to the C++ backend for processing
                                cppInterface.runOptimization(
                                            dimensionsInput.value,
                                            lowerBoundInput.value,
                                            upperBoundInput.value,
                                            gridSizeFactorInputP.value,
                                            gridSizeFactorInputQ.value,
                                            evalsInput.value,
                                            dispFuncName.currentText,
                                            isFuncCheck.checked,
                                            isVectCheck.checked,
                                            withCacheCheck.checked,
                                            withLogCheck.checked,
                                            withOptCheck.checked,
                                            true
                                            )
                            }
                        }
                        Button {
                            text: "Download"
                            onClicked: {
                                cppInterface.downloadSolution()
                            }
                        }
                    }
                    Row {
                        spacing: 20
                        Label {
                            id: downloadStatusLabel
                            text: ""
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                    }
                }

                Connections {
                    target: cppInterface
                    function onOptimizationDone(response) {
                        var result = JSON.parse(response);
                        solverStatus.text = "Done"

                        // Extract the values from the minimum_value string
                        var values = result.minimum_value.split("|").map(function(item) {
                            return item.trim();
                        });

                        functionNameOutput.text = values[0]; // "functionName-Dimention eg. Simple-15d"
                        evalsOutput.text = values[1].split("=")[1]; // "evals eg. 1.00e+05"
                        tOutput.text = values[2].split("=")[1]; // "t_all or t_cur eg. 1.55e+00"
                        var e_XY = values[3]; // "eg. e_x=1.24e-02 e_y=1.40e-05"

                        // Extract the values from the e_x e_y string
                        var e_xyValues = e_XY.split(" ").map(function(item) {
                            return item.trim();
                        });
                        exOutput.text = e_xyValues[0].split("=")[1]; // "e_x eg. 1.52e-02"
                        eyOutput.text = e_xyValues[1].split("=")[1]; // "e_y eg. 2.17e-05"
                    }
                    function onOptimizationError(errorMessage) {
                        solverStatus.text = "Error: " + errorMessage
                    }
                    function onDownloadCompleted(data) {
                        downloadStatusLabel.text = "Download completed successfully"
                        logsTextArea.text = data
                    }
                }
            }

            Row {
                id: functionOutputLog
                width: parent.width
                height: 250
                anchors.top: inputOutputRow.bottom
                anchors.topMargin: 20
                spacing:20
                ScrollView{
                    width: parent.width - 100
                    height: parent.height
                    TextArea {
                        id: logsTextArea
                        readOnly: true
                        font.pixelSize: 14
                        color: "#ffffff"
                    }
                }
                Button {
                    text: "Save"
                    onClicked: {
                        saveFileDialog.open()
                    }
                }
            }
        }
    }

    function saveSettings() {
        dimensions = dimensionsInput.value
        lowerBound = lowerBoundInput.value
        upperBound = upperBoundInput.value
        gridSizeFactorP = gridSizeFactorInputP.value
        gridSizeFactorQ = gridSizeFactorInputQ.value
        evals = evalsInput.value
        funcIndex = dispFuncName.currentIndex
        isFuncChecked = isFuncCheck.checked
        isVectChecked = isVectCheck.checked
        withCache = withCacheCheck.checked
        withLog = withLogCheck.checked
        withOpt = withOptCheck.checked
    }
}
