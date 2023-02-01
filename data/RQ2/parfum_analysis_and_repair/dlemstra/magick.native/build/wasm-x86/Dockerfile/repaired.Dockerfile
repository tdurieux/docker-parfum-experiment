FROM emscripten/emsdk:3.1.5

RUN mkdir /build && mkdir /build/libraries && mkdir /build/shared && mkdir /build/wasm-x86 && mkdir /build/wasm-x86/patches

COPY build/wasm-x86/install.dependencies.sh /build/wasm-x86

RUN cd /build/wasm-x86; ./install.dependencies.sh

COPY src/ImageMagick /ImageMagick

RUN cd /ImageMagick; ./checkout.sh wasm

COPY build/wasm-x86/patches/* /build/wasm-x86/patches/

RUN cd /ImageMagick/libraries; /build/wasm-x86/patches/install.patches.sh

COPY build/libraries/*.sh /build/libraries

COPY build/wasm-x86/settings.sh /build/wasm-x86

COPY build/wasm-x86/build.libraries.sh /build/wasm-x86

COPY build/wasm-x86/cross-compilation.* /build/wasm-x86

RUN cd /ImageMagick/libraries; /build/wasm-x86/build.libraries.sh /build/libraries

COPY build/shared/build.ImageMagick.sh /build/wasm-x86

RUN cd /ImageMagick/libraries; /build/wasm-x86/build.ImageMagick.sh wasm x86

COPY src/Magick.Native /Magick.Native

COPY build/shared/build.Native.sh /build/shared

RUN cd /Magick.Native; /build/shared/build.Native.sh wasm x86

COPY src/create-type-definition /create-type-definition

RUN cd /create-type-definition; npm install && npm run publish && npm cache clean --force;

COPY build/wasm-x86/copy.Native.sh /build
