# README

## Brewfile の作成

```shell
brew bundle dump --no-vscode --file Brewfile
```

## Brewfile に合わせる

```shell
brew bundle install --file Brewfile
brew bundle cleanup --file Brewfile
```

## Brewfile にパッケージを追加・削除

```shell
brew bundle add <name> --file Brewfile
brew bundle remove <name> --file Brewfile
```
