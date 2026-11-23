Unicode true
Name "Flash Studio em português (Brasil)"
OutFile "Instalar-Flash-Studio-PT-BR.exe"
RequestExecutionLevel admin
SetCompressor /SOLID zlib
AutoCloseWindow true
VIProductVersion "1.0.0.0"
VIAddVersionKey "ProductName" "Flash Studio em português (Brasil)"
VIAddVersionKey "FileDescription" "Instalador do catálogo de idioma pt-BR"
VIAddVersionKey "FileVersion" "1.0.0"
VIAddVersionKey "ProductVersion" "1.0.0"
VIAddVersionKey "LegalCopyright" "Distribuído sob a licença AGPL-3.0"

!include "LogicLib.nsh"
!include "MUI2.nsh"
!include "x64.nsh"

!define MUI_HEADER_TEXT "Localizar o Flash Studio"
!define MUI_HEADER_SUBTEXT "Selecione a pasta que contém o arquivo flash-studio.exe."
!define MUI_DIRECTORYPAGE_TEXT_TOP "A instalação não foi encontrada automaticamente. Use Procurar para selecionar a pasta do Flash Studio."
!define MUI_PAGE_CUSTOMFUNCTION_PRE SkipDirectoryPage
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE CheckDirectoryPage
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "PortugueseBR"

Var CatalogFolder
Var StagedFile

Function ValidateDirectory
    ClearErrors
    ${If} $INSTDIR == ""
        SetErrors
    ${ElseIfNot} ${FileExists} "$INSTDIR\flash-studio.exe"
        SetErrors
    ${ElseIfNot} ${FileExists} "$INSTDIR\resources\i18n\*.*"
        SetErrors
    ${EndIf}
FunctionEnd

Function .onInit
    ${If} ${RunningX64}
        SetRegView 64
    ${EndIf}
    ReadRegStr $INSTDIR HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Orca-Flashforge" "InstallLocation"
    Call ValidateDirectory
    IfErrors 0 found
    StrCpy $INSTDIR "$PROGRAMFILES64\Orca-Flashforge"
    Call ValidateDirectory
    IfErrors 0 found
    StrCpy $INSTDIR "$PROGRAMFILES64\Flash Studio"
    Call ValidateDirectory
    IfErrors 0 found
    SetRegView 32
    ReadRegStr $INSTDIR HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Orca-Flashforge" "InstallLocation"
    Call ValidateDirectory
    IfErrors 0 found
    StrCpy $INSTDIR "$PROGRAMFILES32\Orca-Flashforge"
    Call ValidateDirectory
    IfErrors 0 found
    StrCpy $INSTDIR "$PROGRAMFILES32\Flash Studio"
    Call ValidateDirectory
    IfErrors 0 found
    StrCpy $INSTDIR "$PROGRAMFILES64"
found:
FunctionEnd

Function SkipDirectoryPage
    Call ValidateDirectory
    IfErrors +2
    Abort
FunctionEnd

Function CheckDirectoryPage
    Call ValidateDirectory
    IfErrors 0 valid
    MessageBox MB_OK|MB_ICONEXCLAMATION "Selecione a pasta que contém flash-studio.exe e resources\i18n."
    Abort
valid:
FunctionEnd

Section
    Call ValidateDirectory
    IfErrors failed
    StrCpy $CatalogFolder "$INSTDIR\resources\i18n\pt_BR"
    ClearErrors
    SetOutPath "$CatalogFolder"
    IfErrors failed
    GetTempFileName $StagedFile "$CatalogFolder"
    IfErrors failed
    SetOverwrite on
    File /oname=$StagedFile "${CATALOG}"
    IfErrors failed
    ${If} ${FileExists} "$CatalogFolder\Orca-Flashforge.mo"
    ${AndIfNot} ${FileExists} "$CatalogFolder\Orca-Flashforge.mo.bak"
        System::Call 'kernel32::CopyFileW(w "$CatalogFolder\Orca-Flashforge.mo", w "$CatalogFolder\Orca-Flashforge.mo.bak", i 1) i.r0'
        StrCmp $0 0 failed
    ${EndIf}
    System::Call 'kernel32::MoveFileExW(w "$StagedFile", w "$CatalogFolder\Orca-Flashforge.mo", i 9) i.r0'
    StrCmp $0 0 failed
    MessageBox MB_OK|MB_ICONINFORMATION "Português (Brasil) instalado.$\r$\n$\r$\nAbra ou reinicie o Flash Studio e selecione Português (Brasil) nas preferências de idioma." /SD IDOK
    Goto done
failed:
    ${If} $StagedFile != ""
        Delete "$StagedFile"
    ${EndIf}
    SetErrorLevel 1
    MessageBox MB_OK|MB_ICONSTOP "Não foi possível instalar o catálogo. Feche o Flash Studio e tente novamente." /SD IDOK
    Abort
done:
SectionEnd
