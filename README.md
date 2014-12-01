About
=====

My vim settings as a git repo :-)

## To use it

```bash
cd ~
mv .vim .vim.bak # backup old settings
mv .vimrc .vimrc.bak # backup old settings
git clone https://github.com/liyu1981/dotvim.git
mv dotvim .vim
cd .vim
./bundle_init.sh
cd -
ln -s `pwd`/.vim/.vimrc .vimrc
```
