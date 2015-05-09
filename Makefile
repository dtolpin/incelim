VERSION=1.3
PREFIX=rng-incelim
DISTNAME=${PREFIX}-${VERSION}
DIST=${DISTNAME}.zip

XSLT=java -Xms64m -Xmx64m com.sun.xt.xsl.sax.Driver
DBX2HTML_XSL=~/work/docbook/xsl/html/docbook.xsl

.SUFFIXES: .dbx .html .txt

.dbx.html:
	${XSLT} $< ${DBX2HTML_XSL} > $@

.html.txt:
	lynx -dump $< \
	| sed -e '/^References$$/,$$d' \
	     -e '/^ *__* *$$/d' \
	     -e 's/\[[0-9][0-9]*\]//g' \
	     > $@

FILES=\
inc.xsl \
readme.dbx \
readme.txt \
saxon-6.5.3.diff \
incelim \
incelim.xsl \
clean.xsl \
strip.xsl \
elim.xsl \
license.txt

all: ${DIST}
${DIST}: ${FILES}
	-rm -rf ${DISTNAME}
	mkdir ${DISTNAME}
	cp ${FILES} ${DISTNAME}/.
	zip -r ${DIST} ${DISTNAME}

clean:
	-rm -rf ${PREFIX}-* readme.html readme.txt
