/*
 * 
 * This QML file defines the user interface for a function optimization input application.
 * It uses QtQuick and QtQuick.Controls modules to create a GUI with various input controls
 * and displays for optimization parameters and results.
 * 
 * Components:
 * 
 * - ApplicationWindow: The main window of the application.
 * - Row: A horizontal layout to organize the input and output sections.
 * - Column: Vertical layouts within the Row to group related controls.
 * 
 * Input Controls:
 * 
 * - Dimensions (d): A Slider to select the number of dimensions.
 * - Grid Lower Bound (a): A Slider to set the lower bound of the grid.
 * - Grid Upper Bound (b): A Slider to set the upper bound of the grid.
 * - Grid Size Factor (p): A Slider to set the grid size factor p.
 * - Grid Size Factor (q): A Slider to set the grid size factor q.
 * - Number of Evals: A SpinBox to set the number of evaluations.
 * - Display name for function: A ComboBox to select the function to optimize.
 * - Flags and Options: CheckBoxes to set various flags (is_func, is_vect, with_cache, with_log, with_opt).
 * - Run Optimization: A Button to trigger the optimization process.
 * 
 * Output Displays:
 * 
 * - Solver Output: A section to display the results of the optimization.
 * - Convergence Status: A TextArea to show the convergence status.
 * - Solution: A TextArea to display the solution found by the optimizer.
 * - Minima Value: A TextArea to show the minima value of the function.
 * - Download Solution: A Button to download the solution.
 * 
 * Functions:
 * 
 * - getFunctionInfo: A JavaScript function to return information about the selected function.
 * 
 * Connections:
 * 
 * - cppInterface: Connections to handle signals from the C++ backend for optimization results and errors.
 * 
 * Usage:
 * 
 * - Adjust the sliders and input fields to set the optimization parameters.
 * - Select the function to optimize from the ComboBox.
 * - Click the "Run Optimization" button to start the optimization process.
 * - View the results in the output section.
 * - Click the "Download Solution" button to save the solution.
 */
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

ApplicationWindow {
    visible: true
    width: 900
    height: 900
    title: "Function Optimization Input"

    Row {
        spacing: 50
        anchors.margins: 50

        Column {
            spacing: 10

            // Dimension Input (d)
            Label { text: "Dimensions (d):" }
            Slider {
                id: dimensionsInput
                from: 1
                to: 100
                value: 10
                stepSize: 1
                onValueChanged: dimensionsLabel.text = value.toString()
            }
            Label {
                id: dimensionsLabel
                text: dimensionsInput.value.toString()
            }

            // Grid Lower Bound (a)
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

            // Grid Upper Bound (b)
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

            // Grid Size Factor (p)
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

            // Grid Size Factor (q)
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

            // Number of Requests to Function (evals)
            Label { text: "Number of Evals:" }
            SpinBox {
                id: evalsInput
                from: 1
                to: 100000
                value: 100000
            }

            // Display name for func
            Label { text: "Display name for function:" }
            ComboBox {
                id: dispFuncName
                model: ["Simple", "Tensor", "Alpine", "Rosenbrock", "Rastrigin", "Sphere", "Styblinski-Tang"]
                currentIndex: 0 // Default to "Simple"
                onCurrentIndexChanged: {
                    functionInfo.text = "Function Info: " + parent.getFunctionInfo(dispFuncName.currentText)
                }
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

            Label {
                id: functionInfo
                text: "Function Info: " + parent.getFunctionInfo(dispFuncName.currentText)
                wrapMode: TextEdit.Wrap
                width: 300
                height: 100
            }

            // Flags and Options
            CheckBox { id: isFuncCheck; text: "is_func"; checked: true }
            CheckBox { id: isVectCheck; text: "is_vect"; checked: true }
            CheckBox { id: withCacheCheck; text: "with_cache"; checked: false }
            CheckBox { id: withLogCheck; text: "with_log"; checked: true }
            CheckBox { id: withOptCheck; text: "with_opt"; checked: false }

            // Submit Button
            Button {
                text: "Run Optimization"
                onClicked: {
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

        Column {
            spacing: 10

            // Solver Output
            Label { text: "Solver Output: " }
            TextArea {
                id: solverStatus
                readOnly: true
                width: 200
                height: 50
                wrapMode: TextEdit.Wrap
            }

            // Function Name
            Label { text: "Function Name: " }
            TextArea {
                id: functionNameOutput
                readOnly: true
                width: 200
                height: 50
                wrapMode: TextEdit.Wrap
            }

            // Evals
            Label { text: "Evals: " }
            TextArea {
                id: evalsOutput
                readOnly: true
                width: 200
                height: 50
                wrapMode: TextEdit.Wrap
            }

            // t_all or t_cur
            Label { text: "t_all or t_cur: " }
            TextArea {
                id: tOutput
                readOnly: true
                width: 200
                height: 50
                wrapMode: TextEdit.Wrap
            }

            // e_x
            Label { text: "e_x: " }
            TextArea {
                id: exOutput
                readOnly: true
                width: 300
                height: 50
                wrapMode: TextEdit.Wrap
            }

            // e_y
            Label { text: "e_y: " }
            TextArea {
                id: eyOutput
                readOnly: true
                width: 200
                height: 50
                wrapMode: TextEdit.Wrap
            }

            // Download Button
            Button {
                text: "Download Solution "
                // onClicked: {
                //     cppInterface.downloadSolution()
                // }
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
}
