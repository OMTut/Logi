; Inno Setup Script for Logi - Star Citizen Log Monitor
; This script creates a Windows installer for the Logi application with custom Star Citizen theming

[Setup]
; Application Information
AppName=Logi - Star Citizen Log Monitor
AppVersion=1.0.0
AppVerName=Logi - Star Citizen Log Monitor 1.0.0
AppPublisher=Logi

; Installation Settings
DefaultDirName={autopf}\Logi
DefaultGroupName=Logi
AllowNoIcons=yes
DisableProgramGroupPage=yes
CreateUninstallRegKey=yes
LicenseFile=
InfoBeforeFile=
InfoAfterFile=
OutputDir=output
OutputBaseFilename=LogiSetup
SetupIconFile=..\release\Logo_Logi_v1_desktop.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

; Display Settings
ShowLanguageDialog=no

; Windows Version Requirements
MinVersion=0,10.0
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

; Uninstall Settings
UninstallDisplayName=Logi - Star Citizen Log Monitor
UninstallDisplayIcon={app}\Logi.exe 

; Privileges
PrivilegesRequired=admin

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Main application and all dependencies
Source: "..\release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
; Desktop icon (optional, based on user choice)
Name: "{autodesktop}\Logi"; Filename: "{app}\Logi.exe"; IconFilename: "{app}\Logo_Logi_v1_desktop.ico"; Tasks: desktopicon

[Run]
; Launch app after installation - for both regular install and silent updates
; This ensures automatic restart after updates
Filename: "{app}\Logi.exe"; Description: "{cm:LaunchProgram,Logi}"; Flags: nowait postinstall

[Messages]
; Override default messages with custom text
WelcomeLabel1=Welcome to the Logi Setup Wizard
WelcomeLabel2=This will install Logi - Star Citizen Log Monitor on your computer.%n%nLogi helps you monitor and analyze your Star Citizen game logs in real-time.%n%nIt is recommended that you close all other applications before continuing.
SelectDirDesc=Logi will be installed in the following folder. Click Browse to select a different folder, or click Next to continue.
SelectDirBrowseLabel=To continue, click Next. If you would like to select a different folder, click Browse.
ReadyLabel1=Setup is now ready to install Logi on your computer.
ReadyLabel2a=Click Install to continue with the installation, or click Back if you want to review or change any settings.
ReadyLabel2b=Click Install to continue with the installation.
FinishedHeadingLabel=Completing the Logi Setup Wizard
FinishedLabelNoIcons=Setup has finished installing Logi on your computer.
FinishedLabel=Setup has finished installing Logi on your computer. The application may be launched by selecting the installed shortcuts.
ClickFinish=Click Finish to exit Setup.

