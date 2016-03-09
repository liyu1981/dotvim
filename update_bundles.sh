for d in `ls`; do cd $d; git checkout master; git pull; cd -; done
