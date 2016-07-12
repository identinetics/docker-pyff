#!/usr/bin/env bash

# optional script to initialize and update the docker build environment

update_pkg="False"

while getopts ":hnu" opt; do
  case $opt in
    n)
      update_pkg="False"
      ;;
    u)
      update_pkg="True"
      ;;
    *)
      echo "usage: $0 [-n] [-u]
   -n  do not update git repos in docker build context (default)
   -u  update git repos in docker build context

   To update packages delivered as tar-balls just delete them from install/opt
   "
      exit 0
      ;;
  esac
done

shift $((OPTIND-1))


workdir=$(cd $(dirname $BASH_SOURCE[0]) && pwd)
cd $workdir
source ./conf${config_nr}.sh

get_or_update_repo() {
    if [ -e $repodir ] ; then
        [ "$update_pkg" ] \
            && echo "updating $repodir" \
            && cd $repodir && git pull && cd $OLDPWD
    else
        echo "cloning $repodir" \
        mkdir -p $repodir
        git clone $repourl $repodir        # first time
    fi
}

get_from_tarball() {
    if [ ! -e $pkgroot/$pkgdir ]; then \
        [ "$update_pkg" ] \
            echo "downloading $pkgdir into $pkgroot" \
            mkdir $pkgroot/$pkgdir \
            curl -L $pkgurl | tar -xz -C $pkgroot
    fi
}

get_from_ziparchive() {
    if [ ! -e $pkgroot/$pkgdir ]; then
        if [ "$update_pkg" == "True" ]; then
            echo "downloading $pkgdir into $pkgroot"
            mkdir $pkgroot/$pkgdir
            wget -qO- -O tmp.zip $pkgurl && unzip tmp.zip && rm tmp.zip
        fi
    fi
}



# --- pyXMLSecurity ---
repodir='install/opt/pyXMLSecurity'
repourl='https://github.com/rhoerbe/pyXMLSecurity'
get_or_update_repo

# --- pyFF ---
repodir='install/opt/pyff'
repourl='https://github.com/identinetics/pyFF'
get_or_update_repo

# --- XMLSECTOOL ---
repodir='xmlsectool-2'
version='2.0.0'
cd "$workdir/install/opt/"
if [ ! -e $repodir ]; then
    echo "downloading xmlsectool-${version}-bin.zip"
    wget "https://shibboleth.net/downloads/tools/xmlsectool/${version}/xmlsectool-${version}-bin.zip"
    unzip "xmlsectool-${version}-bin.zip"
    ln -s "xmlsectool-${version}" $repodir
    rm "xmlsectool-${version}-bin.zip"
fi
