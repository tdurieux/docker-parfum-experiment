FROM ubuntu:14.04
MAINTAINER xymostech <xymostech@gmail.com>

# Install things
RUN apt-get -qq update && apt-get -qqy --no-install-recommends install git dvipng default-jre default-jdk texlive wget fontforge mftrace fonttools optipng advancecomp man-db build-essential unzip zlib1g-dev python-fontforge ruby woff-tools || true && rm -rf /var/lib/apt/lists/*;
RUN gem install ttfunk --version 1.1.1

# Download yuicompressor
RUN mkdir /usr/share/yui-compressor/
RUN wget "https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.jar" -O /usr/share/yui-compressor/yui-compressor.jar

# Download batik-ttf2svg.jar
RUN wget "https://supergsego.com/apache/xmlgraphics/batik/batik-1.7.zip"
RUN unzip -qq batik-1.7.zip
RUN mv batik-1.7/batik-ttf2svg.jar /usr/share/java/

# Download and compile ttf2eof (note we add a patch to make it compile)
RUN wget "https://ttf2eot.googlecode.com/files/ttf2eot-0.0.2-2.tar.gz"
RUN tar -xzf ttf2eot-0.0.2-2.tar.gz && rm ttf2eot-0.0.2-2.tar.gz
RUN sed -i "1s/^/#include <cstddef>/" ttf2eot-0.0.2-2/OpenTypeUtilities.h
RUN make -C ttf2eot-0.0.2-2/
RUN mv ttf2eot-0.0.2-2/ttf2eot /usr/bin/

# Download and compile woff2_compress
RUN git clone "https://code.google.com/p/font-compression-reference/" woff2_compress
RUN make -C woff2_compress/woff2/
RUN mv woff2_compress/woff2/woff2_compress /usr/bin/

# Download and setup MathJax-dev
RUN git clone "https://github.com/khan/MathJax-dev.git"
RUN cp MathJax-dev/default.cfg MathJax-dev/custom.cfg
RUN make -C MathJax-dev custom.cfg.pl

