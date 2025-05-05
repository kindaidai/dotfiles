# dotfiles

chezmoi https://www.chezmoi.io/

## 事前準備
###  Bacbookの設定
- VSCode vim の長押しを有効にする
```shell
$ defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false         # For VS Code
$ defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false # For VS Code Insider
```
- homebrew を入れる


## Get started

### 1. Clone dotfiles

```sh
$ brew install chezmoi
# 新しいマシンの場合は、sshの設定がまだの可能性があるので、https経由でcloneする
$ chezmoi init https://github.com/kindaidai/dotfiles.git
```

### 2. Login to 1Password

```sh
$ brew install 1password-cli
# 1Passwordから秘密鍵を取得してくるので、ログインしておく。初回は、secret keyが必要
$ eval $(op signin --account my.1password.com)
```

### 3. Apply dotfiles

```sh
$ chezmoi apply
```

### 4. Setup

#### Homebrew

```sh
$ cd ~/.config/brewfile/
$ brew bundle --file ./Brewfile
```

#### vim

https://github.com/junegunn/vim-plug


```sh
$ cd .vim
# https://github.com/junegunn/vim-plug?tab=readme-ov-file#unix
$ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
$ vim #任意のdir
# vim内で `:PlugInstall` を実行
```

#### gpg

- [既存の GPG キーの確認](https://docs.github.com/ja/authentication/managing-commit-signature-verification/checking-for-existing-gpg-keys)

- [Git へ署名キーを伝える](https://docs.github.com/ja/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)
- [commit で署名を確認](https://docs.github.com/ja/authentication/managing-commit-signature-verification/signing-commits)
- 1Password から pub.key, sec.key をダウンロードする

```sh
$ cp ~/Downloads/pub.key ~/.ssh/gpg/
$ cp ~/Downloads/sec.key ~/.ssh/gpg/

# 現在の GPG 設定を確認
$ git config --global user.signingkey
# 鍵が存在するか確認
$ gpg --list-secret-keys --keyid-format LONG
# for fish shell
$ brew reinstall pinentry-mac
# 対象の秘密鍵を再インポート
$ gpg --import path/to/private-key.asc
# GPGエージェントが動いているか確認
$ gpgconf --launch gpg-agent
# pinentry-mac が入ってないときはインストール
$ brew install pinentry-mac
# 設定ファイルを更新
$ echo "use-agent" >> ~/.gnupg/gpg.conf
$ echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
$ killall gpg-agent

# 適当にREADMEを更新して、確認
$ chezmoi cd
#なんか更新する
$ git add .
$ git commit -S -m 'hoge' # コミットできればOK
```

#### ssh

```sh
$ ssh -T github
Hi kindaidai! You've successfully authenticated, but GitHub does not provide shell access.
```

#### Claude
- cluade_desktop_config.json は、`~/Library/Application\ Support/Claude/claude_desktop_config.json`に配置しなおす

### 5. chezmoi 管理下のファイルに変更があった場合

- `chezmoi diff`で変更があるか確認

- `~/.local/share/chezmoi`を直接変更した場合

  - 変更内容を反映先のファイルに適用する必要がある

  ```sh
  $ git add .
  $ git commit -S -m 'hoge'
  $ git push origin main
  # 各ファイルが反映される
  $ chezmoi apply
  ```

- `~/.local/share/chezmoi`以外のファイルを変更した場合
  - 変更内容を chezmoi 管理のファイルに適用する必要がある
  ```sh
  $ chezmoi re-add path/to/file
  or
  $ chezmoi re-add --template path/to/file
  $ chezmoi cd
  $ git add .
  $ git commit -S -m 'hoge'
  $ git push origin main
  ```

#### homebrew の場合

- brew-file でアプリを管理している

```sh
$ brew install xxx # or brew uninstall xxxx
$ brew-file dump
$ chezmoi re-add ~/.config/brewfile/Brewfile
```

#### dir ごと chezmoi に反映

```
$ chezmoi add ~/.ssh/fish
```
