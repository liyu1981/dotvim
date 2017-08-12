# usage:
#   cd bundle
#   ../update_bundle.sh
for d in `ls`; do cd $d; git checkout master; git pull; cd -; done
