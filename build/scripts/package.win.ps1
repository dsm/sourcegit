Remove-Item -Path build\SourceGit\*.pdb -Force
Compress-Archive -Path build\SourceGit -DestinationPath "build\sourcegit_${env:VERSION}.${env:RUNTIME}.zip" -Force

$installer = @"
#define AppVersion "$($env:VERSION)"
#define Runtime "$($env:RUNTIME)"

[Setup]
AppId={{96FE8F9D-2D1D-4E94-BD1F-C1EEA0D57FD7}
AppName=SourceGit
AppVersion={#AppVersion}
DefaultDirName={localappdata}\SourceGit
DisableProgramGroupPage=yes
OutputDir=build
OutputBaseFilename=sourcegit_{#AppVersion}.{#Runtime}.setup
Compression=lzma
SolidCompression=yes
PrivilegesRequired=lowest
WizardStyle=modern
ArchitecturesAllowed=x64compatible arm64
ArchitecturesInstallIn64BitMode=x64compatible arm64

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"

[Files]
Source: "SourceGit\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autodesktop}\SourceGit"; Filename: "{app}\SourceGit.exe"; Tasks: desktopicon
"@

$script = "build\sourcegit.installer.iss"
Set-Content -Path $script -Value $installer -Encoding utf8
& "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe" $script
