function Component()
{
    // Constructor
}

Component.prototype.beginInstallation = function()
{
    // This is called right before installation begins - last chance to modify target directory
    var targetDir = installer.value("TargetDir");
    console.log("Original target directory in beginInstallation: " + targetDir);
    
    if (!targetDir.match(/[\\/]Logi$/i)) {
        targetDir = targetDir.replace(/[\\/]+$/, "");
        if (targetDir.indexOf("\\") !== -1) {
            targetDir += "\\Logi";
        } else {
            targetDir += "/Logi";
        }
        installer.setValue("TargetDir", targetDir);
        console.log("Modified target directory in beginInstallation: " + targetDir);
    }
}

Component.prototype.createOperations = function()
{
    // Call default implementation
    component.createOperations();
    
    if (systemInfo.productType === "windows") {
        // Create desktop shortcut
        component.addOperation("CreateShortcut", 
                             "@TargetDir@/Logi.exe", 
                             "@DesktopDir@/Logi.lnk",
                             "workingDirectory=@TargetDir@",
                             "iconPath=@TargetDir@/Logi.exe",
                             "description=Star Citizen Log Monitor");
        
        // Create start menu shortcut
        component.addOperation("CreateShortcut", 
                             "@TargetDir@/Logi.exe", 
                             "@StartMenuDir@/Logi.lnk",
                             "workingDirectory=@TargetDir@",
                             "iconPath=@TargetDir@/Logi.exe", 
                             "description=Star Citizen Log Monitor");
    }
}

Component.prototype.installationFinished = function()
{
    if (!installer.isInstaller())
        return;
        
    // Show completion message
    var message = "Logi has been successfully installed!\n\n";
    message += "You can now launch Logi from:\n";
    message += "• Desktop shortcut\n";
    message += "• Start menu\n";
    message += "• " + installer.value("TargetDir") + "/Logi.exe";
    
    installer.setValue("FinishedText", message);
}