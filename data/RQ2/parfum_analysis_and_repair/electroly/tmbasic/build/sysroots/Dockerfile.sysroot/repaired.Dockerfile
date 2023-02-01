FROM $IMAGE_ARCH/alpine:3.15
RUN apk update && apk upgrade && apk add --no-cache clang linux-headers g++ musl-dev

# Install ICU natively. I can get it to cross-compile but the resulting ICU doesn't have the locale data properly
# loaded. That seems fixable but until then, doing it here will work.

# https://github.com/unicode-org/icu/releases
RUN apk add --no-cache curl make
RUN cd /tmp && \
	curl -f -L https://github.com/unicode-org/icu/releases/download/release-70-1/icu4c-70_1-src.tgz | tar zx && \
	curl -f -L -o icu/source/config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' && \
	curl -f -L -o icu/source/config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD' && \
    mkdir -p icu/source/build && \
    cd icu/source/build && \
    CXXFLAGS="-DU_USING_ICU_NAMESPACE=0 -DU_NO_DEFAULT_INCLUDE_UTF_HEADERS=1 -DU_HIDE_OBSOLETE_UTF_OLD_H=1 -std=c++17" \
        ../runConfigureICU "Linux/gcc" --enable-static --disable-shared --disable-tests --disable-samples \
        --with-data-packaging=static && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/icu

RUN rm -rf /usr/bin/* && rm -rf /usr/local/bin/* && rm -rf /bin/*
