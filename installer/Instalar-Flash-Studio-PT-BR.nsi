Unicode true
Name "Flash Studio em português (Brasil)"
OutFile "Instalar-Flash-Studio-PT-BR.exe"
RequestExecutionLevel admin
SetCompressor /SOLID zlib
AutoCloseWindow true
VIProductVersion "1.0.1.0"
VIAddVersionKey "ProductName" "Flash Studio em português (Brasil)"
VIAddVersionKey "FileDescription" "Instalador do catálogo de idioma pt-BR"
VIAddVersionKey "FileVersion" "1.0.1"
VIAddVersionKey "ProductVersion" "1.0.1"
VIAddVersionKey "LegalCopyright" "Distribuído sob a licença AGPL-3.0"

!include "LogicLib.nsh"
!include "MUI2.nsh"
!include "x64.nsh"

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
    StrCpy $INSTDIR "C:\Program Files\Flashforge\Flash Studio Desktop"
    Call ValidateDirectory
    IfErrors 0 found
    StrCpy $INSTDIR "$PROGRAMFILES64\Flashforge\Flash Studio Desktop"
    Call ValidateDirectory
    IfErrors 0 found
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
    StrCpy $INSTDIR "$PROGRAMFILES32\Flashforge\Flash Studio Desktop"
    Call ValidateDirectory
    IfErrors 0 found
    IfSilent missing

choose:
    Call ChooseDirectory
    IfErrors cancelled
    Call ValidateDirectory
    IfErrors 0 found
    MessageBox MB_OK|MB_ICONEXCLAMATION "Selecione a pasta que contém flash-studio.exe e resources\i18n."
    Goto choose

missing:
    SetErrorLevel 1
cancelled:
    Abort
found:
FunctionEnd

Function ChooseDirectory
    ; Inicializa COM no thread da interface e abre o seletor moderno do Explorer.
    System::Call 'ole32::CoInitializeEx(p 0, i 2) i.r0'
    IntCmp $0 0 initialized dialog_error initialized
initialized:
    System::Call 'ole32::CoCreateInstance(g "{DC1C5A9C-E88A-4DDE-A5A1-60F82A20AEF7}", p 0, i 1, g "{D57C7288-D4AD-4768-BE02-9D969532D960}", *p .r1) i.r0'
    StrCmp $0 0 0 uninitialize_error

    ; IFileDialog::SetOptions: PICKFOLDERS, FORCEFILESYSTEM, PATHMUSTEXIST e NOCHANGEDIR.
    System::Call '$1->9(i 0x868) i.r0'
    StrCmp $0 0 0 release_dialog
    System::Call '$1->17(w "Selecione a pasta do Flash Studio") i.r0'
    System::Call '$1->3(p $HWNDPARENT) i.r0'
    StrCmp $0 0 0 release_dialog
    System::Call '$1->20(*p .r2) i.r0'
    StrCmp $0 0 0 release_dialog

    ; IShellItem::GetDisplayName com SIGDN_FILESYSPATH.
    System::Call '$2->5(i 0x80058000, *p .r3) i.r0'
    StrCmp $0 0 0 release_item
    System::Call 'kernel32::lstrlenW(p r3) i.r4'
    IntCmp $4 ${NSIS_MAX_STRLEN} path_too_long copy_path path_too_long
copy_path:
    System::Call 'kernel32::lstrcpynW(w .r5, p r3, i ${NSIS_MAX_STRLEN}) p'
    StrCpy $INSTDIR $5
    Goto free_path
path_too_long:
    StrCpy $0 -1
free_path:
    System::Call 'ole32::CoTaskMemFree(p r3)'
release_item:
    System::Call '$2->2() i'
release_dialog:
    System::Call '$1->2() i'
uninitialize_error:
    System::Call 'ole32::CoUninitialize()'
    StrCmp $0 0 selected
    IntCmp $0 -2147023673 cancelled dialog_error dialog_error
dialog_error:
    MessageBox MB_OK|MB_ICONSTOP "O Windows não conseguiu abrir o seletor de pastas ou ler o caminho selecionado."
cancelled:
    SetErrors
    Return
selected:
    ClearErrors
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
