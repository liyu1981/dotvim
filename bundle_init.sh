git submodule init
git submodule update

# build firepirate
cd bundle/filepirate/plugin/
make
cd -

# brew install Ag
sudo brew install the_silver_searcher
