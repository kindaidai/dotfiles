# dotfiles

chezmoi https://www.chezmoi.io/

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
# for fish shell
$ eval (op signin --account my.1password.com)
```

### 3. Apply dotfiles

```sh
# applyする前にtemplateの分岐を確認する。.chezmoi.hostname "kindaichidainoMacBook-Air" みたいなのがある
$ chezmoi execute-template '{{ .chezmoi.hostname }}'
> kindaichidainoMacBook-Air
# 違う場合は、書き換える
$ chezmoi apply
```

### 4. Setup

#### Homebrew

```sh
$ cd ~/.config/brewfile/
$ brew file install
```

#### anyenv

```sh
# config.fishの読み込みでこけないようにする
$ anyenv install --init
$ anyenv install rbenv
```

#### vim

https://github.com/Shougo/dein.vim#quick-start

```sh
$ cd .vim
$ curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
$ sh ./installer.sh ./bundles
$ vim #任意のdirで実行し、自動でtomlファイルからプラグインをインポートする
```

#### gpg

- [既存の GPG キーの確認](https://docs.github.com/ja/authentication/managing-commit-signature-verification/checking-for-existing-gpg-keys)

- [Git へ署名キーを伝える](https://docs.github.com/ja/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)
- [commit で署名を確認](https://docs.github.com/ja/authentication/managing-commit-signature-verification/signing-commits)
- 1Password から pub.key, sec.key をダウンロードする

```sh
$ cp ~/Downloads/pub.key ~/.ssh/gpg/
$ cp ~/Downloads/sec.key ~/.ssh/gpg/
# for fish shell
$ brew reinstall pinentry-mac
$ echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
$ killall gpg-agent
# gpgを確認する
$ gpg --list-secret-keys --keyid-format=long
$ gpg --armor --export xxxxxxxxxxxxx
# 必要であれば
$ git config --global user.signingkey xxxxxxxxxxxxx
# 適当にREADMEを更新して、確認
$ chezmoi cd
$ #なんか更新する
$ git add .
$ git commit -S -m 'hoge'
$ git push origin main
```

#### ssh

```sh
$ ssh -T github
Hi kindaidai! You've successfully authenticated, but GitHub does not provide shell access.
```

### chezmoi 管理下のファイルに変更があった場合

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
  $ chezmoi add path/to/file
  or
  $ chezmoi add --template path/to/file
  $ chezmoi cd
  $ git add .
  $ git commit -S -m 'hoge'
  $ git push origin main
  ```
