package main

import (
	"bytes"
	"crypto/md5"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

func setPortuguese(config []byte) ([]byte, error) {
	config = bytes.TrimSpace(bytes.TrimPrefix(config, []byte{0xef, 0xbb, 0xbf}))
	if i := bytes.LastIndex(config, []byte("\n# MD5 checksum ")); i >= 0 {
		config = bytes.TrimSpace(config[:i])
	}

	sections := make(map[string]json.RawMessage)
	if len(config) > 0 {
		if err := json.Unmarshal(config, &sections); err != nil || sections == nil {
			return nil, fmt.Errorf("Formato de Orca-Flashforge.conf inválido")
		}
	}
	settings := make(map[string]json.RawMessage)
	if app, exists := sections["app"]; exists {
		if err := json.Unmarshal(app, &settings); err != nil || settings == nil {
			return nil, fmt.Errorf("A seção app de Orca-Flashforge.conf está inválida")
		}
	}
	if bytes.Equal(settings["language"], []byte(`"pt_BR"`)) {
		return nil, nil
	}
	settings["language"] = json.RawMessage(`"pt_BR"`)
	app, err := json.Marshal(settings)
	if err != nil {
		return nil, err
	}
	sections["app"] = app

	var output bytes.Buffer
	encoder := json.NewEncoder(&output)
	encoder.SetEscapeHTML(false)
	encoder.SetIndent("", "    ")
	if err = encoder.Encode(sections); err != nil {
		return nil, err
	}
	digest := md5.Sum(bytes.TrimSuffix(output.Bytes(), []byte("\n")))
	fmt.Fprintf(&output, "# MD5 checksum %X\n", digest)
	return output.Bytes(), nil
}

func replaceConfig(path string, data []byte) error {
	temp, err := os.CreateTemp(filepath.Dir(path), ".flash-studio-language-*")
	if err != nil {
		return err
	}
	defer os.Remove(temp.Name())
	_, writeErr := temp.Write(data)
	closeErr := temp.Close()
	if writeErr != nil {
		return writeErr
	}
	if closeErr != nil {
		return closeErr
	}
	return os.Rename(temp.Name(), path)
}

func applyLanguage(path string) error {
	original, err := os.ReadFile(path)
	exists := err == nil
	if !exists && !os.IsNotExist(err) {
		return err
	}
	updated, err := setPortuguese(original)
	if err != nil || updated == nil {
		return err
	}
	if err := os.MkdirAll(filepath.Dir(path), 0700); err != nil {
		return err
	}
	if exists {
		if err := replaceConfig(path+".pt-br.bak", original); err != nil {
			return err
		}
	}
	return replaceConfig(path, updated)
}
