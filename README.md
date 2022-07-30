# dotfiles

chezmoi https://www.chezmoi.io/

## Get started

#### 1. Clone dotfiles

```sh
$ brew install chezmoi
$ chezmoi init git@github.com:kindaidai/dotfiles.git
```

#### 2. Login to 1password cli

```sh
# for fish shell
$ brew install 1password-cli
$ eval (op signin --account my.1password.com)
```

#### 3. Apply dotfiles

```
chezmoi apply
```

#### 4. setup

```sh
$ cd ~/.config/brewfile/
$ brew file install
$ gpg --import path/to/gpg-secret.key
$ vim #任意のdirで実行し、自動でtomlファイルからプラグインをインポートする
```
