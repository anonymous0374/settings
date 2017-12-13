# filename: publish.fin.sh
# purpose: compile multiple projects and integrate the output ready for
#   publishing
# author: j-sparrow
# date: 2017-12-04 14:41 p.m.
#
# basic steps:
#   1 get directories based on parameters
#   2 do cleaning
#   3 compile project A into A/dist
#   4 compile project B into B/dist
#   5 merge A/dist with B/dist into directory C
#   6 commit C to svn
#   (opt: 7 go to http://tone.tf56.lo/tone/pages/apply/develop.html to publish)

while getopts v: option
do
  case "${option}" in
  v) version=${OPTARG};;
  esac
done

case $version in
  1.2)
    echo version 1.2
    prj1Root=./front-b2b-v1.2.0
    prj2Root=./mpa_v1.2
    publishRoot=./publish/front-b2b-v1.2.0
;;
  1.2.1)
    echo version 1.2.1
    prj1Root=./front-b2b-v2.0
    prj2Root=./mpa_v2.0
    publishRoot=./publish/frontB2B_V1.2.1
;;
  1.2.2)
    echo version 1.2.2
    prj1Root=./front-b2b-v1.2.2
    prj2Root=./mpa_v1.2.2
    publishRoot=./publish/frontB2B_v1.2.2
;;
  2.0)
    echo version 2.0
    prj1Root=./front-b2b-v2.0
    prj2Root=./mpa_v2.0
    publishRoot=./publish/frontB2B_v2.0
;;
  *)
    echo 'please give a valid version number(1.2 or 1.2.1 or 1.2.2 or 2.0), program exit'
    exit 1
esac

wd=$(pwd)

# clean up
cd $publishRoot
svn delete ./*  --force && svn commit -m 'clear up'
mkdir mpa
cd $wd
#rm -rf $publishRoot/* && mkdir $publishRoot/mpa/

# compile prj1
cd $prj1Root && npm run release
cp -ruv dist/* ../$publishRoot/
cd $wd

# compile prj2
cd $prj2Root && npm run release
cp -r ./dist/* ../$publishRoot/mpa/
cd $wd

# update svn
cd $publishRoot
svn add . --force && svn commit -m 'publishing'
cd $wd
