FROM texmlbus_latexml_git_edge as latexml_edge

# This is an extract of the original Dockerfile in LaTeXML/relase/docker/Dockerfile.
# The first part has been put into texmlbus_latexml_base, while the second part is found here.
# By splitting the content into several files, changes can be applied without complete reinstallation of TeX.

# Configure if we test during the build
ARG WITH_TESTS="no"

# Install the dependencies

# Make a directory for latexml
RUN mkdir -p /opt/latexml

# Add all of the source files
ADD bin/            /opt/latexml/bin
#ADD doc/            /opt/latexml/doc/
ADD lib/            /opt/latexml/lib
#ADD release/        /opt/latexml/release/
ADD t/              /opt/latexml/t/
ADD tools/          /opt/latexml/tools/
#ADD Changes         /opt/latexml/Changes
#ADD INSTALL         /opt/latexml/INSTALL
#ADD INSTALL.SKIP    /opt/latexml/INSTALL.SKIP
ADD LICENSE         /opt/latexml/LICENSE
ADD Makefile.PL     /opt/latexml/Makefile.PL
#ADD MANIFEST        /opt/latexml/MANIFEST
#ADD MANIFEST.SKIP   /opt/latexml/MANIFEST.SKIP
#ADD manual.pdf      /opt/latexml/manual.pdf
#ADD README.pod      /opt/README.pod

# Installing  via cpanm (with or without tests)
WORKDIR /opt/latexml

RUN if [ "$WITH_TESTS" == "no" ] ; then cpanm --notest . ; else cpanm . ; fi