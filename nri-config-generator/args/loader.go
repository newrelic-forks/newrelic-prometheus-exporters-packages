package args

import (
	"os"
	"strings"
)

const (
	prefixEnv     = "env"
	prefixCfg     = "config"
	prefixCLI     = "cli"
	envConfigPath = "CONFIG_PATH"
)

func PopulateVars(vars map[string]interface{}) (err error) {
	vars[prefixEnv] = envVars()
	vars[prefixCLI] = cliVars()
	vars[prefixCfg], err = argVars()
	return
}

func envVars() map[string]string {
	vars := make(map[string]string)
	for _, e := range os.Environ() {
		pair := strings.SplitN(e, "=", 2)
		vars[pair[0]] = pair[1]
	}
	delete(vars, envConfigPath)
	return vars
}

func cliVars() map[string]string {
	vars := make(map[string]string)
	name := ""
	for i := range os.Args {
		arg := os.Args[i]
		if strings.HasPrefix(arg, "-") {
			name = strings.TrimPrefix(arg, "-")
			continue
		}
		if name != "" {
			vars[name] = arg
		}
	}
	return vars
}
