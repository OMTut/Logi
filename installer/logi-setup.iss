; Inno Setup Script for Logi - Star Citizen Log Monitor
; This script creates a Windows installer for the Logi application

[Setup]
; Application Information
AppName=Logi - Star Citizen Log Monitor
AppVersion=1.0.0
AppVerName=Logi - Star Citizen Log Monitor 1.0.0
AppPublisher=Logi
AppPublisherURL=https://github.com/yourname/logi
AppSupportURL=https://github.com/yourname/logi
AppUpdatesURL=https://github.com/yourname/logi

; Installation Settings
DefaultDirName={autopf}\Logi
DefaultGroupName=Logi
AllowNoIcons=yes
LicenseFile=
InfoBeforeFile=
InfoAfterFile=
OutputDir=output
OutputBaseFilename=LogiSetup
SetupIconFile=..\release\Logo_Logi_v1_desktop.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

; Windows Version Requirements
MinVersion=0,6.1sp1
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64

; Uninstall Settings
UninstallDisplayName=Logi - Star Citizen Log Monitor
UninstallDisplayIcon={app}\Logi.exe

; Privileges
PrivilegesRequired=lowest

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
; Main application and all dependencies
Source: "..\release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\Logi"; Filename: "{app}\Logi.exe"; IconFilename: "{app}\Logo_Logi_v1_desktop.ico"
Name: "{group}\{cm:UninstallProgram,Logi}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\Logi"; Filename: "{app}\Logi.exe"; IconFilename: "{app}\Logo_Logi_v1_desktop.ico"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\Logi"; Filename: "{app}\Logi.exe"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\Logi.exe"; Description: "{cm:LaunchProgram,Logi}"; Flags: nowait postinstall skipifsilent

[CustomMessages]
; Custom messages for better user experience
english.WelcomeLabel1=Welcome to the Logi Setup Wizard
english.WelcomeLabel2=This will install Logi - Star Citizen Log Monitor on your computer.%n%nLogi helps you monitor and analyze your Star Citizen game logs in real-time.%n%nIt is recommended that you close all other applications before continuing.
english.SelectDirDesc=Logi will be installed in the following folder. Click Browse to select a different folder, or click Next to continue.
english.SelectDirBrowseLabel=To continue, click Next. If you would like to select a different folder, click Browse.
english.DiskSpaceGBLabel=At least {0} GB of free disk space is required.
english.DiskSpaceMBLabel=At least {0} MB of free disk space is required.
english.DiskSpaceKBLabel=At least {0} KB of free disk space is required.
english.CannotContinueNoSpace=Setup cannot continue. At least {0} of free disk space is required.
english.SelectComponentsDesc=Which components should be installed?
english.SelectComponentsLabel2=Select the components you want to install; clear the components you do not want to install. Click Next when you are ready to continue.
english.ReadyLabel1=Setup is now ready to install Logi on your computer.
english.ReadyLabel2a=Click Install to continue with the installation, or click Back if you want to review or change any settings.
english.ReadyLabel2b=Click Install to continue with the installation.
english.NeedRestart=To complete the installation of Logi, Setup must restart your computer. Would you like to restart now?
english.NeedRestartWarning=Warning: If you do not restart now, you will need to restart before Logi will run properly.
english.RunEntryExec=Run Logi
english.RunEntryShellExec=View Logi Documentation

[Messages]
; Override default messages with custom text
WelcomeLabel1=Welcome to the Logi Setup Wizard
WelcomeLabel2=This will install Logi - Star Citizen Log Monitor on your computer.%n%nLogi helps you monitor and analyze your Star Citizen game logs in real-time.%n%nIt is recommended that you close all other applications before continuing.
SelectDirDesc=Logi will be installed in the following folder. Click Browse to select a different folder, or click Next to continue.
SelectDirBrowseLabel=To continue, click Next. If you would like to select a different folder, click Browse.
DiskSpaceGBLabel=At least %1 GB of free disk space is required.
DiskSpaceMBLabel=At least %1 MB of free disk space is required.
DiskSpaceKBLabel=At least %1 KB of free disk space is required.
CannotContinueNoSpace=Setup cannot continue. At least %1 of free disk space is required.
ReadyLabel1=Setup is now ready to install Logi on your computer.
ReadyLabel2a=Click Install to continue with the installation, or click Back if you want to review or change any settings.
ReadyLabel2b=Click Install to continue with the installation.
FinishedHeadingLabel=Completing the Logi Setup Wizard
FinishedLabelNoIcons=Setup has finished installing Logi on your computer.
FinishedLabel=Setup has finished installing Logi on your computer. The application may be launched by selecting the installed shortcuts.
ClickFinish=Click Finish to exit Setup.