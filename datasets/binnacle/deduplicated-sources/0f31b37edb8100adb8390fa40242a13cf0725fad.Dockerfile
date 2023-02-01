# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

FROM gcr.io/oss-fuzz-base/base-builder
MAINTAINER officesecurity@lists.freedesktop.org
# enable source repos
RUN sed -i -e '/^#\s*deb-src.*\smain\s\+restricted/s/^#//' /etc/apt/sources.list
#build requirements
RUN apt-get update && apt-get build-dep -y libreoffice
RUN apt-get update && apt-get install -y wget yasm
#cache build dependencies
ADD https://dev-www.libreoffice.org/src/c3c1a8ba7452950636e871d25020ce0d-pt-serif-font-1.0000W.tar.gz \
    https://dev-www.libreoffice.org/src/c74b7223abe75949b4af367942d96c7a-crosextrafonts-carlito-20130920.tar.gz \
    https://dev-www.libreoffice.org/src/e7a384790b13c29113e22e596ade9687-LinLibertineG-20120116.zip \
    https://dev-www.libreoffice.org/src/edc4d741888bc0d38e32dbaa17149596-source-sans-pro-2.010R-ro-1.065R-it.tar.gz \
    https://dev-www.libreoffice.org/src/907d6e99f241876695c19ff3db0b8923-source-code-pro-2.030R-ro-1.050R-it.tar.gz \
    https://dev-www.libreoffice.org/src/134d8262145fc793c6af494dcace3e71-liberation-fonts-ttf-1.07.4.tar.gz \
    https://dev-www.libreoffice.org/src/1725634df4bb3dcb1b2c91a6175f8789-GentiumBasic_1102.zip \
    https://dev-www.libreoffice.org/src/33e1e61fab06a547851ed308b4ffef42-dejavu-fonts-ttf-2.37.zip \
    https://dev-www.libreoffice.org/src/368f114c078f94214a308a74c7e991bc-crosextrafonts-20130214.tar.gz \
    https://dev-www.libreoffice.org/src/5c781723a0d9ed6188960defba8e91cf-liberation-fonts-ttf-2.00.1.tar.gz \
    https://dev-www.libreoffice.org/src/7a15edea7d415ac5150ea403e27401fd-open-sans-font-ttf-1.10.tar.gz \
    https://dev-www.libreoffice.org/src/EmojiOneColor-SVGinOT-1.3.tar.gz \
    https://dev-www.libreoffice.org/src/a8c2c5b8f09e7ede322d5c602ff6a4b6-mythes-1.2.4.tar.gz \
    https://dev-www.libreoffice.org/src/5ade6ae2a99bc1e9e57031ca88d36dad-hyphen-2.8.8.tar.gz \
    https://dev-www.libreoffice.org/src/48d647fbd8ef8889e5a7f422c1bfda94-clucene-core-2.3.3.4.tar.gz \
    https://dev-www.libreoffice.org/src/boost_1_63_0.tar.bz2 \
    https://dev-www.libreoffice.org/src/expat-2.2.1.tar.bz2 \
    https://dev-www.libreoffice.org/src/libjpeg-turbo-1.5.1.tar.gz \
    https://dev-www.libreoffice.org/src/lcms2-2.8.tar.gz \
    https://dev-www.libreoffice.org/src/0168229624cfac409e766913506961a8-ucpp-1.3.2.tar.gz \
    https://dev-www.libreoffice.org/src/10d61fbaa6a06348823651b1bd7940fe-libexttextcat-3.4.4.tar.bz2 \
    https://dev-www.libreoffice.org/src/1f5def51ca0026cd192958ef07228b52-rasqal-0.9.33.tar.gz \
    https://dev-www.libreoffice.org/src/a39f6c07ddb20d7dd2ff1f95fa21e2cd-raptor2-2.0.15.tar.gz \
    https://dev-www.libreoffice.org/src/e5be03eda13ef68aabab6e42aa67715e-redland-1.0.17.tar.gz \
    https://dev-www.libreoffice.org/src/cppunit-1.14.0.tar.gz \
    https://dev-www.libreoffice.org/src/openldap-2.4.44.tgz \
    https://dev-www.libreoffice.org/src/231adebe5c2f78fded3e3df6e958878e-neon-0.30.1.tar.gz \
    https://dev-www.libreoffice.org/src/e80ebae4da01e77f68744319f01d52a3-pixman-0.34.0.tar.gz \
    https://dev-www.libreoffice.org/src/cairo-1.14.8.tar.xz \
    https://dev-www.libreoffice.org/src/curl-7.52.1.tar.gz \
    https://dev-www.libreoffice.org/src/xmlsec1-1.2.24.tar.gz \
    https://dev-www.libreoffice.org/src/liblangtag-0.6.2.tar.bz2 \
    https://dev-www.libreoffice.org/src/libabw-0.1.1.tar.bz2 \
    https://dev-www.libreoffice.org/src/libcdr-0.1.3.tar.bz2 \
    https://dev-www.libreoffice.org/src/libcmis-0.5.1.tar.gz \
    https://dev-www.libreoffice.org/src/libe-book-0.1.2.tar.bz2 \
    https://dev-www.libreoffice.org/src/libetonyek-0.1.6.tar.bz2 \
    https://dev-www.libreoffice.org/src/libfreehand-0.1.1.tar.bz2 \
    https://dev-www.libreoffice.org/src/libmspub-0.1.2.tar.bz2 \
    https://dev-www.libreoffice.org/src/libmwaw-0.3.12.tar.xz \
    https://dev-www.libreoffice.org/src/libodfgen-0.1.6.tar.bz2 \
    https://dev-www.libreoffice.org/src/liborcus-0.12.1.tar.gz \
    https://dev-www.libreoffice.org/src/libpagemaker-0.0.3.tar.bz2 \
    https://dev-www.libreoffice.org/src/libpng-1.6.30.tar.xz \
    https://dev-www.libreoffice.org/src/librevenge-0.0.4.tar.bz2 \
    https://dev-www.libreoffice.org/src/libstaroffice-0.0.4.tar.xz \
    https://dev-www.libreoffice.org/src/libvisio-0.1.5.tar.bz2 \
    https://dev-www.libreoffice.org/src/libwpd-0.10.1.tar.bz2 \
    https://dev-www.libreoffice.org/src/libwpg-0.3.1.tar.bz2 \
    https://dev-www.libreoffice.org/src/libwps-0.4.7.tar.xz \
    https://dev-www.libreoffice.org/src/libzmf-0.0.1.tar.bz2 \
    https://dev-www.libreoffice.org/src/zlib-1.2.11.tar.xz \
    https://dev-www.libreoffice.org/src/poppler-0.56.0.tar.xz \
    https://dev-www.libreoffice.org/src/mdds-1.2.3.tar.bz2 \
    https://dev-www.libreoffice.org/src/openssl-1.0.2k.tar.gz \
    https://dev-www.libreoffice.org/src/language-subtag-registry-2017-04-19.tar.bz2 \
    https://dev-www.libreoffice.org/src/graphite2-minimal-1.3.10.tgz \
    https://dev-www.libreoffice.org/src/harfbuzz-1.3.2.tar.bz2 \
    https://dev-www.libreoffice.org/src/bae83fa5dc7f081768daace6e199adc3-glm-0.9.4.6-libreoffice.zip \
    https://dev-www.libreoffice.org/src/icu4c-59_1-src.tgz \
    https://dev-www.libreoffice.org/src/icu4c-59_1-data.zip \
    https://dev-www.libreoffice.org/src/ae249165c173b1ff386ee8ad676815f5-libxml2-2.9.4.tar.gz \
    https://dev-www.libreoffice.org/src/a129d3c44c022de3b9dcf6d6f288d72e-libxslt-1.1.29.tar.gz \
    https://dev-www.libreoffice.org/src/047c3feb121261b76dc16cdb62f54483-hunspell-1.6.0.tar.gz \
    https://dev-www.libreoffice.org/src/freetype-2.7.1.tar.bz2 \
    https://dev-www.libreoffice.org/src/fontconfig-2.12.4.tar.bz2 \
    https://dev-www.libreoffice.org/src/libepoxy-1.3.1.tar.bz2 \
    https://dev-www.libreoffice.org/src/gpgme-1.8.0.tar.bz2 \
    https://dev-www.libreoffice.org/src/libassuan-2.4.3.tar.bz2 \
    https://dev-www.libreoffice.org/src/libgpg-error-1.26.tar.bz2 $SRC/
#fuzzing corpuses
ADD http://lcamtuf.coredump.cx/afl/demo/afl_testcases.tgz $SRC/
RUN mkdir afl-testcases && cd afl-testcases/ && tar xf $SRC/afl_testcases.tgz && cd .. && \
    zip -q $SRC/jpgfuzzer_seed_corpus.zip afl-testcases/jpeg*/full/images/* && \
    zip -q $SRC/giffuzzer_seed_corpus.zip afl-testcases/gif*/full/images/* && \
    zip -q $SRC/bmpfuzzer_seed_corpus.zip afl-testcases/bmp*/full/images/* && \
    zip -q $SRC/pngfuzzer_seed_corpus.zip afl-testcases/png*/full/images/*
ADD https://dev-www.libreoffice.org/corpus/wmffuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/xbmfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/xpmfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/svmfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/pcdfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/dxffuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/metfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/ppmfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/psdfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/epsfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/pctfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/pcxfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/rasfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/tgafuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/tiffuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/hwpfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/602fuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/lwpfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/pptfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/rtffuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/olefuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/cgmfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/ww2fuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/ww6fuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/ww8fuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/qpwfuzzer_seed_corpus.zip \
    https://dev-www.libreoffice.org/corpus/slkfuzzer_seed_corpus.zip $SRC/
#clone source
RUN git clone --depth 1 git://anongit.freedesktop.org/libreoffice/core libreoffice
WORKDIR libreoffice
COPY build.sh $SRC/
