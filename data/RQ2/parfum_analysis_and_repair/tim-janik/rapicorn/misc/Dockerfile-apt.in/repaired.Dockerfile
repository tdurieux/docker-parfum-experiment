# This Source Code Form is licensed MPL-2.0: http://mozilla.org/MPL/2.0

# Pick distribution to start from
FROM @DIST@
MAINTAINER Tim Janik <timj@gnu.org>

# Automation tools and convenience commands
ENV DEBIAN_FRONTEND noninteractive
RUN echo '#!/bin/bash\n"$@" || { sleep 10 ; "$@" ; } || { sleep 90 ; "$@" ; }' > /bin/retry && \
    echo '#!/bin/sh\ncase "$INTENT" in *$1*) echo true ;; *) echo "exit 0" ;; esac' > /bin/intent && \
    echo '#!/bin/sh\nprintf "\\033[31;1m"\nprintf %s "$*" | sed '\''1{h;s/./*/g;p;x;};${p;x}'\'' >&2\nprintf "\\033[0m\\n"' > /bin/warn && \
    chmod +x /bin/retry /bin/intent /bin/warn && \
    echo '\n' \
    "\nalias ls='ls --color=auto' ; alias l='ls -al' ;" \
    "\nalias grep='grep --color=auto' ; alias fgrep='fgrep --color=auto' ; alias egrep='egrep --color=auto' ;" \
    '\nfunction regrep { (shopt -s globstar extglob; IFS=; set - ; /usr/bin/nice /bin/egrep --color=auto -d skip "") }' \
    | tee -a /etc/bash.bashrc >> /root/.bashrc

# Add bintray.com repo key for which dirmngr is needed and enable https apt sources
RUN retry apt-get update && \
    retry apt-get install -y apt-utils dirmngr apt-transport-https ca-certificates && \
    retry apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61 && \
    retry apt-get -y upgrade

# Provide build essentials
RUN retry apt-get install -y \
    build-essential devscripts lintian automake autoconf autoconf-archive libtool intltool \
    doxygen graphviz texlive-binaries pandoc git libxml2-utils

# Provide clang++ if needed
ENV  INTENT		"@INTENT@"
RUN `intent clangbuild` && \
    retry apt-get install -y clang

# Provide dependencies
RUN retry apt-get install -y \
    bison flex cython xvfb \
    librsvg2-dev libpango1.0-dev python2.7-dev libxml2-dev libreadline6-dev \
    libreadline-dev python-all-dev python-enum34
ENV BINTRAY_REPO	"@BINTRAY_REPO@"
ENV DISTRELEASE		"@DISTRELEASE@"

# Setup build environment and provide the git repository
ENV PROJECT	@PROJECT@
ENV EMAIL	rapicorn@googlegroups.com
COPY tmp-mirror.git /tmp/$PROJECT.git
RUN cd /usr/src/ && \
    git clone /tmp/$PROJECT.git

# Build sources in project directory
WORKDIR /usr/src/$PROJECT

# Build sources, run tests and create distribution tarball
# Carry out distcheck test if desired
RUN : && \
    case $INTENT in \
      *clangbuild*) nice ./autogen.sh --prefix=/usr CC=clang CXX=clang++ ;; \
      *gccbuild*)   nice ./autogen.sh --prefix=/usr ;; \
    esac
RUN nice make -j`nproc`
RUN nice make check
RUN nice make install
RUN nice make installcheck
RUN nice make dist
RUN nice make uninstall

# Carry out distcheck test if desired
RUN `intent distcheck` && \
    nice make distcheck

# Show tarball
RUN ls -l *.tar.xz

# Create deb packages as follows:
# Figure Debian version, this must have a distribution specific suffix for bintray uploads.
# Extract distribution from tarball, prepare debian source tarball, add debian/ directory,
# update Debian's 'changelog', install build tools, build Debian packages in /usr/src/.
ENV  DIST		"@DIST@"
ENV  TRAVIS_JOB_NUMBER	"@TRAVIS_JOB_NUMBER@"
RUN `intent package` && \
    TARBALL=`echo *.tar.xz` && \
    TARDIR=${TARBALL%.tar*} && \
    TARPACKAGE=${TARDIR%-*} && \
    TARVERSION=${TARDIR#*-} && \
    BUILDID=`misc/mkbuildid.sh -p` && \
    DEBVERSION=$BUILDID-0${DISTRELEASE:-local}${TRAVIS_JOB_NUMBER:+~travis${TRAVIS_JOB_NUMBER#*.}} && \
    DEB_TARBALL="$TARPACKAGE"_"${DEBVERSION%-*}.orig.tar.xz" && \
    COMMITID=`git rev-parse HEAD` && \
    CHANGELOGMSG="Development snapshot, git commit $COMMITID" && \
    cp $TARBALL ../$DEB_TARBALL && \
    cd ../ && \
    tar xf $DEB_TARBALL && \
    cd $TARDIR/ && \
    cp -r ../$TARPACKAGE/debian/ . && \
    dch -v "$DEBVERSION" "$CHANGELOGMSG" && \
    dch -r "" && \
    cat debian/changelog && \
    retry apt-get install -y $(dpkg-checkbuilddeps 2>&1 | sed 's/.*: //') && \
    nice debuild -j`nproc` -rfakeroot -us -uc && \
    cd .. && \
  rm -r $TARDIR/ && \
    ls -al

# Test package installation from /usr/src/ and removal locally
RUN `intent package` && \
    cd .. && \
    dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz && \
    echo 'deb [trusted=yes] file:///usr/src ./' > /etc/apt/sources.list.d/usrsrc.list && \
    retry apt-get update && \
    apt-get install --no-install-recommends -y rapicorn && \
    apt-get purge -y rapicorn && \
    apt-get --purge -y autoremove && \
    rm /etc/apt/sources.list.d/usrsrc.list && \
    retry apt-get update && rm -rf /var/lib/apt/lists/*;

# Upload packages
COPY tmp-bintray-token .bintraytoken
RUN `intent bintrayup` && \
    ls -al .. && \
    misc/bintrayup.sh .bintraytoken $DIST $BINTRAY_REPO/rapicorn ../*.deb && \
    rm .bintraytoken

# Test installation from remote (sleep & retry allow for extra bintray.com indexing time)
RUN `intent bintrayup` && \
    sleep 60 && \
    echo "deb [trusted=yes] https://dl.bintray.com/$BINTRAY_REPO $DISTRELEASE main" | \
	tee /etc/apt/sources.list.d/bintray-source-line.list && \
    retry /bin/sh -c 'apt-get update && apt-get install -y rapicorn' || \
	warn '* WARNING: Failed package installation after bintray.com upload *'

# docker build -t @PROJECT@ .
# docker run -ti --rm @PROJECT@ /bin/bash
