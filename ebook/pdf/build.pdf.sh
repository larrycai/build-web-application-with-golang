#!/bin/sh

SED='sed'

if [ `uname -s` = 'Darwin' ]; then
  SED='gsed'
fi

bn="`basename $0`"
WORKDIR="$(cd $(dirname $0); pwd -P)"

#
# Default language: zh
# You can overwrite following variables in config file.
#
MSG_INSTALL_LATEX_FIRST='请先安装latex，然后再次运行'
MSG_SUCCESSFULLY_PDF_GENERATED='build-web-application-with-golang.pdf 已经建立'
MSG_CREATOR='Astaxie'
MSG_DESCRIPTION='一本开源的Go Web编程书籍'
MSG_LANGUAGE='zh-CN'
MSG_TITLE='Go Web编程'
[ -e "$WORKDIR/config" ] && . "$WORKDIR/config"

TMP=`mktemp -d 2>/dev/null || mktemp -d -t "${bn}"` || exit 1
trap 'rm -rf "$TMP"' 0 1 2 3 15

cd "$TMP"

if [ ! type -P xelatex >/dev/null 2>&1 ]; then
	echo "$MSG_INSTALL_LATEX_FIRST"
	exit 0
fi

mkdir -p $TMP/images
cp -r $WORKDIR/../images/* $TMP/images/
cp $WORKDIR/../[0-9]*.md $TMP
cp $WORKDIR/go.tex $TMP
cp $WORKDIR/meta.txt $TMP
ls [0-9]*.md | xargs $SED -i "s/png?raw=true/png/g"

multimarkdown -t latex meta.txt `ls [0-9]*.md | sort` -o chapters.tex

#exit
xelatex -interaction=nonstopmode go.tex
xelatex -interaction=nonstopmode go.tex
xelatex -interaction=nonstopmode go.tex
cp go.pdf $WORKDIR/../../build-web-application-with-golang.pdf

#ebook-convert $WORKDIR/../build-web-application-with-golang.epub $WORKDIR/../build-web-application-with-golang.pdf

echo "$MSG_SUCCESSFULLY_PDF_GENERATED"
