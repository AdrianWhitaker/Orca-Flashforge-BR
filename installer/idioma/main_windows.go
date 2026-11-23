package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"syscall"
	"unsafe"
)

func studioRunning() (bool, error) {
	snapshot, err := syscall.CreateToolhelp32Snapshot(syscall.TH32CS_SNAPPROCESS, 0)
	if err != nil {
		return false, err
	}
	defer syscall.CloseHandle(snapshot)
	process := syscall.ProcessEntry32{}
	process.Size = uint32(unsafe.Sizeof(process))
	for err = syscall.Process32First(snapshot, &process); err == nil; err = syscall.Process32Next(snapshot, &process) {
		switch strings.ToLower(syscall.UTF16ToString(process.ExeFile[:])) {
		case "flash studio.exe", "flash-studio.exe", "orca-flashforge.exe":
			return true, nil
		}
	}
	if err == syscall.ERROR_NO_MORE_FILES {
		return false, nil
	}
	return false, err
}

func activate(installDir string) error {
	running, err := studioRunning()
	if err != nil {
		return err
	}
	if running {
		return fmt.Errorf("Feche o Flash Studio e execute o instalador novamente")
	}

	dataDir := filepath.Join(installDir, "data_dir")
	info, err := os.Stat(dataDir)
	if os.IsNotExist(err) {
		userConfigDir, err := os.UserConfigDir()
		if err != nil {
			return err
		}
		dataDir = filepath.Join(userConfigDir, "Orca-Flashforge")
	} else if err != nil {
		return err
	} else if !info.IsDir() {
		return fmt.Errorf("data_dir não é uma pasta")
	}
	return applyLanguage(filepath.Join(dataDir, "Orca-Flashforge.conf"))
}

func main() {
	if len(os.Args) != 2 {
		os.Exit(1)
	}
	if err := activate(os.Args[1]); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
