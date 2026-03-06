package main

import (
	"github.com/alecthomas/kong"
)

type CLI struct {
	Init   InitCmd   `cmd:"" help:"Setup a new machine from dotfiles."`
	Update UpdateCmd `cmd:"" help:"Pull latest dotfiles changes."`
}

func main() {
	cli := CLI{}
	ctx := kong.Parse(&cli,
		kong.Name("stp"),
		kong.Description("Dotfiles setup tool — clone, configure, and symlink your configs."),
		kong.UsageOnError(),
	)
	err := ctx.Run()
	ctx.FatalIfErrorf(err)
}
