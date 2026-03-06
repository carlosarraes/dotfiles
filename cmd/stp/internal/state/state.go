package state

import (
	"os"
	"path/filepath"

	"github.com/carraes/dotfiles/cmd/stp/internal/pathutil"
	"gopkg.in/yaml.v3"
)

type Config struct {
	ClonePath string   `yaml:"clone_path"`
	Packages  []string `yaml:"packages"`
}

func configPath() string {
	return filepath.Join(pathutil.ConfigDir(), "config.yaml")
}

func Save(cfg *Config) error {
	path := configPath()
	if err := os.MkdirAll(filepath.Dir(path), 0755); err != nil {
		return err
	}
	data, err := yaml.Marshal(cfg)
	if err != nil {
		return err
	}
	return os.WriteFile(path, data, 0644)
}

func Load() (*Config, error) {
	data, err := os.ReadFile(configPath())
	if err != nil {
		return nil, err
	}
	var cfg Config
	if err := yaml.Unmarshal(data, &cfg); err != nil {
		return nil, err
	}
	return &cfg, nil
}
