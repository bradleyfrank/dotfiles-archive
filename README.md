# Brad's Configs & Scripts

A collection of configuration files and scripts for MacOS and Linux.

## Deployment

Use `GNU Stow` to symlink each package into place. I've automated the process with the [stow-dotfiles](https://github.com/bradleyfrank/dotfiles/blob/master/bin/.local/bin/stow-dotfiles) script. As of Dec 2019 there was a bug using the `dot-` prefix instead of actual hidden files, but I intend to revisit this in the future.