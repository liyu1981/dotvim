git submodule init
git submodule update

# build firepirate
cd bundle/filepirate/plugin/
make
cd -

# brew install Ag
if hash brew 2>/dev/null; then
  sudo brew install the_silver_searcher
else
  echo 'You need install silver_searcher by your own.'
fi
