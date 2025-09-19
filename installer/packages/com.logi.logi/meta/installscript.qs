function Component()
{
    // Constructor
}

Component.prototype.createOperations = function()
{
    // Call default implementation
    component.createOperations();
    
    if (systemInfo.productType === "windows") {
        // Create desktop shortcut
        component.addOperation("CreateShortcut", 
                             "@TargetDir@/appLogi.exe", 
                             "@DesktopDir@/Logi.lnk",
                             "workingDirectory=@TargetDir@",
                             "iconPath=@TargetDir@/appLogi.exe",
                             "description=Star Citizen Log Monitor");
        
        // Create start menu shortcut
        component.addOperation("CreateShortcut", 
                             "@TargetDir@/appLogi.exe", 
                             "@StartMenuDir@/Logi.lnk",
                             "workingDirectory=@TargetDir@",
                             "iconPath=@TargetDir@/appLogi.exe", 
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
    message += "• " + installer.value("TargetDir") + "/appLogi.exe";
    
    installer.setValue("FinishedText", message);
}