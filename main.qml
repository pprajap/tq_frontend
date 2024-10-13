import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

ApplicationWindow {
    width: 1300
    height: 950
    visible: true
    title: "TERRA QUANTUM GUI"

    ScrollView {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            color: "darkgrey"

            Row {
                id: titleBar
                width: parent.width-50
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                Label {
                    anchors.fill: parent
                    text: "TTOptimizor"
                }
            }

            Row {
                id: ioRow
                width: parent.width-50
                height: 500
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: titleBar.bottom
                anchors.topMargin: 10
                spacing: 10
                Column {
                    width: 2 * parent.width / 3
                    height: parent.height
                    spacing: 10

                    Row {
                        // Display name for func
                        spacing: 10
                        Label { text: "Function:" }
                        ComboBox {
                            id: dispFuncName
                            model: ["Simple", "Tensor", "Alpine", "Rosenbrock", "Rastrigin", "Sphere", "Styblinski-Tang"]
                            currentIndex: 0 // Default to "Simple"
                            onCurrentIndexChanged: {
                                console.log("onCurrentIndexChanged: "+currentIndex);
                                functionInfo.text = parent.getFunctionInfo(dispFuncName.currentText)
                            }
                        }
                        Label {
                            id: functionInfo
                            text: parent.getFunctionInfo(dispFuncName.currentText)
                        }
                        function getFunctionInfo(functionName) {
                            switch (functionName) {
                                case "Alpine":
                                    return "f(x) = sum(abs(x * sin(x) + 0.1 * x)), x in [-10, 10]";
                                case "Simple":
                                    return "f(x) = sin(0.1 * x[0])**2 + 0.1 * sum(x[1:]**2), x in [-1, 1]";
                                case "Tensor":
                                    return "f(i) = (i[0] - 2)**2 + (i[1] - 3)**2 + sum(i[2:]**4), i in [0, 1, 2, 3]";
                                case "Rosenbrock":
                                    return "f(x) = sum(100 * (x[i+1] - x[i]**2)**2 + (1 - x[i])**2), x in [-2.048, 2.048]";
                                case "Rastrigin":
                                    return "f(x) = 10 * d + sum(x[i]**2 - 10 * cos(2 * pi * x[i])), x in [-5.12, 5.12]";
                                case "Sphere":
                                    return "f(x) = sum(x**2), x in [-5.12, 5.12]";
                                case "Styblinski-Tang":
                                    return "f(x) = 0.5 * sum(x**4 - 16 * x**2 + 5 * x), x in [-5, 5]";
                                default:
                                    return "No information available.";
                            }
                        }
                    }

                    Row {
                        // Dimension Input (d)
                        spacing: 10
                        Label { text: "Dimensions (d):" }
                        Slider {
                            id: dimensionsInput
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
                        }
                    }

                    Row {
                        // Grid Lower Bound (a)
                        spacing: 10
                        Label { text: "Grid Lower Bound (a):" }
                        Slider {
                            id: lowerBoundInput
                            from: -10.0
                            to: 10.0
                            value: -1.0
                            stepSize: 0.1
                            onValueChanged: lowerBoundLabel.text = value.toString()
                        }
                        Label {
                            id: lowerBoundLabel
                            text: lowerBoundInput.value.toString()
                        }
                    }

                    Row {
                        // Grid Upper Bound (b)
                        spacing: 10
                        Label { text: "Grid Upper Bound (b):" }
                        Slider {
                            id: upperBoundInput
                            from: -10.0
                            to: 10.0
                            value: 1.0
                            stepSize: 0.1
                            onValueChanged: upperBoundLabel.text = value.toString()
                        }
                        Label {
                            id: upperBoundLabel
                            text: upperBoundInput.value.toString()
                        }
                    }

                    Row {
                        // Grid Size Factor (p)
                        spacing: 10
                        Label { text: "Grid Size Factor (p):" }
                        Slider {
                            id: gridSizeFactorInputP
                            from: 1
                            to: 20
                            value: 4
                            stepSize: 1
                            onValueChanged: gridSizeFactorLabelP.text = value.toString()
                        }
                        Label {
                            id: gridSizeFactorLabelP
                            text: gridSizeFactorInputP.value.toString()
                        }
                    }

                    Row {
                        // Grid Size Factor (q)
                        spacing: 10
                        Label { text: "Grid Size Factor (q):" }
                        Slider {
                            id: gridSizeFactorInputQ
                            from: 1
                            to: 20
                            value: 4
                            stepSize: 1
                            onValueChanged: gridSizeFactorLabelQ.text = value.toString()
                        }
                        Label {
                            id: gridSizeFactorLabelQ
                            text: gridSizeFactorInputQ.value.toString()
                        }
                    }

                    Row {
                        // Number of Requests to Function (evals)
                        spacing: 10
                        Label { text: "Number of Evals:" }
                        SpinBox {
                            id: evalsInput
                            from: 1
                            to: 100000
                            value: 100000
                        }
                    }

                    Row {
                        // Flags and Options
                        spacing: 10
                        CheckBox { id: isFuncCheck; text: "is_func"; checked: true }
                        CheckBox { id: isVectCheck; text: "is_vect"; checked: true }
                    }

                    Row {
                        // Flags and Options
                        spacing: 10
                        CheckBox { id: withCacheCheck; text: "with_cache"; checked: false }
                        CheckBox { id: withLogCheck; text: "with_log"; checked: true }
                        CheckBox { id: withOptCheck; text: "with_opt"; checked: false }
                    }

                    Row {
                        // Submit Button
                        spacing: 10
                        Button {
                            text: "Run Optimization"
                            onClicked: {
                                console.log("Button clicked: Run Optimization");
                                console.log("Dimensions:", dimensionsInput.value);
                                console.log("Lower Bound:", lowerBoundInput.value);
                                console.log("Upper Bound:", upperBoundInput.value);
                                console.log("Grid Size Factor P:", gridSizeFactorInputP.value);
                                console.log("Grid Size Factor Q:", gridSizeFactorInputQ.value);
                                console.log("Evaluations:", evalsInput.value);
                                console.log("Function Name:", dispFuncName.currentText);
                                console.log("Is Function:", isFuncCheck.checked);
                                console.log("Is Vector:", isVectCheck.checked);
                                console.log("With Cache:", withCacheCheck.checked);
                                console.log("With Log:", withLogCheck.checked);
                                console.log("With Optimization:", withOptCheck.checked);
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
                    height: parent.height
                    spacing: 10

                    Row {
                        // Solver Output
                        spacing: 10
                        Label { text: "Solver Output: " }
                        TextArea {
                            id: solverStatus
                            readOnly: true
                        }
                    }

                    Row {
                        spacing: 10
                        // Function Name
                        Label { text: "Function Name: " }
                        TextArea {
                            id: functionNameOutput
                            readOnly: true
                        }
                    }

                    Row {
                        spacing: 10
                        // Evals
                        Label { text: "Evals: " }
                        TextArea {
                            id: evalsOutput
                            readOnly: true
                        }
                    }

                    Row {
                        spacing: 10
                        // t_all or t_cur
                        Label { text: "t_all or t_cur: " }
                        TextArea {
                            id: tOutput
                            readOnly: true
                        }
                    }

                    Row {
                        spacing: 10
                        // e_x
                        Label { text: "e_x: " }
                        TextArea {
                            id: exOutput
                            readOnly: true
                        }
                    }

                    Row {
                        spacing: 10
                        // e_y
                        Label { text: "e_y: " }
                        TextArea {
                            id: eyOutput
                            readOnly: true
                        }
                    }

                    Row {
                        spacing: 10
                        // Download Button
                        Button {
                            text: "Download Solution "
                            // onClicked: {
                            //     cppInterface.downloadSolution()
                            // }
                        }
                    }
                }

                Connections {
                    target: cppInterface
                    function onOptimizationDone(response) {
                        var result = JSON.parse(response);
                        solverStatus.text = "SUCCESS"

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
                }
            }

            Row {
                id: functionOutputLog
                width: parent.width-50
                height: 400
                anchors.top: ioRow.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle{
                    anchors.fill: parent
                    color: "lightgrey"
                }

            }
        }

    }
}
