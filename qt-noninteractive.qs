// qt-noninteractive.qs
function Controller() {
    // Auto-accept the licenses
    installer.setAutoAcceptLicenses(true);
    console.log("Licenses auto-accepted");
}

Controller.prototype.IntroductionPageCallback = function() {
    // Bypass the introduction page
    console.log("IntroductionPageCallback triggered");
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.CredentialsPageCallback = function() {
    // Enter login credentials
    console.log("CredentialsPageCallback triggered");
    var widget = gui.currentPageWidget();
    widget.loginWidget.EmailLineEdit.setText(installer.environmentVariable("QT_ACCOUNT_EMAIL"));
    widget.loginWidget.PasswordLineEdit.setText(installer.environmentVariable("QT_ACCOUNT_PASSWORD"));
    console.log("Entered login credentials");
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.TargetDirectoryPageCallback = function() {
    // Set the target directory for installation
    console.log("TargetDirectoryPageCallback triggered");
    var widget = gui.currentPageWidget();
    widget.TargetDirectoryLineEdit.setText("/opt/Qt");
    console.log("Set target directory to /opt/Qt");
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ComponentSelectionPageCallback = function() {
    // Select the required components
    console.log("ComponentSelectionPageCallback triggered");
    var widget = gui.currentPageWidget();
    widget.deselectAll();
    widget.selectComponent("qt.qt6.680.gcc_64");
    widget.selectComponent("qt.qt6.680.wasm_multithread");
    widget.selectComponent("qt.qt6.680.wasm_singlethread");
    console.log("Selected components: qt.qt6.680.gcc_64, qt.qt6.680.wasm_multithread, qt.qt6.680.wasm_singlethread");
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.LicenseAgreementPageCallback = function() {
    // Accept the license agreement
    console.log("LicenseAgreementPageCallback triggered");
    gui.clickButton(buttons.AcceptLicenseButton);
    console.log("License agreement accepted");
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ReadyForInstallationPageCallback = function() {
    // Start the installation
    console.log("ReadyForInstallationPageCallback triggered");
    gui.clickButton(buttons.NextButton);
    console.log("Installation started");
}

Controller.prototype.FinishedPageCallback = function() {
    // Finish the installation
    console.log("FinishedPageCallback triggered");
    gui.clickButton(buttons.FinishButton);
    console.log("Installation finished");
}

var controller = new Controller();