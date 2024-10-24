// qt-noninteractive.qs
function Controller() {
    // Auto-accept the licenses
    installer.setAutoAcceptLicenses(true);
}

Controller.prototype.IntroductionPageCallback = function() {
    // Bypass the introduction page
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.CredentialsPageCallback = function() {
    // Enter login credentials
    var widget = gui.currentPageWidget();
    widget.loginWidget.EmailLineEdit.setText(installer.environmentVariable("QT_ACCOUNT_EMAIL"));
    widget.loginWidget.PasswordLineEdit.setText(installer.environmentVariable("QT_ACCOUNT_PASSWORD"));
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.TargetDirectoryPageCallback = function() {
    // Set the target directory for installation
    var widget = gui.currentPageWidget();
    widget.TargetDirectoryLineEdit.setText("/opt/Qt");
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ComponentSelectionPageCallback = function() {
    // Select the required components
    var widget = gui.currentPageWidget();
    widget.deselectAll();
    widget.selectComponent("qt.qt6.680.gcc_64");
    widget.selectComponent("qt.qt6.680.wasm_multithread");
    widget.selectComponent("qt.qt6.680.wasm_singlethread");
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.LicenseAgreementPageCallback = function() {
    // Accept the license agreement
    gui.clickButton(buttons.AcceptLicenseButton);
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ReadyForInstallationPageCallback = function() {
    // Start the installation
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.FinishedPageCallback = function() {
    // Finish the installation
    gui.clickButton(buttons.FinishButton);
}

var controller = new Controller();