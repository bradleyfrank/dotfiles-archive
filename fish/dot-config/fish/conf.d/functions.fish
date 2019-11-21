function coil -d "Updates Anaconda environment"
  ekans
  command conda update -n base conda -y
  command conda update --prefix /usr/local/anaconda3 anaconda -y
  command conda clean --all -y
  command conda deactivate
end

function condense
  command grep -Erv "(^#|^\$)"
end

function clint -d "Quick and dirty docker-compose linter"
  commanddocker-compose -f $argv[1] config --quiet
end

function code -d "Opens VSCodium (MacOS and Linux) with optional files passed"
  if test (type -t code) = "file"
    command code $argv
  else
    command codium $argv
  end
end

function decrypt -d "Decrypt a file using openssl"
  openssl enc -d -aes-256-cbc -in $argv[1] -out $argv[1].decrypted
end

function ekans
  . /usr/local/anaconda3/bin/activate
end

function encrypt -d "Encrypt a file using openssl"
  openssl enc -aes-256-cbc -salt -in $argv[1] -out $argv[1].encrypted
end

function gedit -d "Detach gedit from the terminal session and supress output"
  nohup /usr/bin/gedit $argv >/dev/null 2>&1
end

function httptrace -d "Show website http headers; follow redirects"
  curl -s -L -D - $argv -o /dev/null -w "%{url_effective}\n"
end

function mydots -d "Updates dotfiles repo and re-stows packages"
  if ! pushd "$HOME"/.dotfiles >/dev/null 2>&1; return; end
  git stash
  git pull
  git submodule update --init --recursive
  for dir in */
    stow --restow --no-folding (string replace '/' '' $dir)
  end
  if ! popd >/dev/null 2>&1; return; end
end

function fproc -d "Custom ps output: fproc [pid|name]"
  if string match --regex '^[0-9]+$' $argv[1]
    set pid (ps -o sid= -p $argv[1])
  else
    set pid (pgrep $argv[1])
  end
  ps -e --forest -o pid,ppid,user,time,cmd -g $pid
end

function steep -d "Update HomeBrew packages and casks"
  brew update
  brew upgrade
  brew cask upgrade
  brew cleanup
end

function tardir -d "tar and gzip a given directory"
  set filename (string replace '/' '' $argv[1])
  tar -czf $filename.tar.gz $argv[1]
end

function youtube-dl-music -d "Download YouTube video as music only"
  switch "(uname -s)"
    case Linux
      youtube-dl -x --audio-format m4a $argv[1]
    case '*'
      youtube-dl -x --audio-format m4a --postprocessor-args "-strict experimental" $argv[1]
  end
end