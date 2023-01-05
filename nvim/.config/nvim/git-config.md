# Git Configs

Algumas configs q uso no meu git!

## Shell

Mudar <ide> para o editor utilizado.

```
git config --global core.editor <ide>
git config --global --edit
```

## Configs and Aliases

É bom utilizar o editor para o VsCode, outros IDEs (acho) q n precisam.

```
[core]
  editor = code --wait
[push]
  followTags = true
[alias]
  s = !git status -s
  c = !git add --all && git commit -m
  l = !git log --pretty=format:'%C(green)%cr: %C(blue)%cn -%C(cyan)%d %C(red)%h %C(white)%s'
  r = !git rebase -i HEAD~2
  amend = !git add --all && git commit --amend --no-edit
  count = !git shortlog -s --grep
  fp = !git push -u origin
```
