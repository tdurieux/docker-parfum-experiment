FROM alpine:edge
RUN apk add --no-cache --update alpine-sdk linux-headers

RUN wget https://github.com/fredrikwidlund/libdynamic/releases/download/v2.3.0/libdynamic-2.3.0.tar.gz && \
    tar fvxz libdynamic-2.3.0.tar.gz && \
    ( cd libdynamic-2.3.0/ && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install) && rm libdynamic-2.3.0.tar.gz

RUN wget https://github.com/fredrikwidlund/libreactor/releases/download/v2.0.0-alpha/libreactor-2.0.0.tar.gz && \
    tar fvxz libreactor-2.0.0.tar.gz && \
    ( cd libreactor-2.0.0; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install) && rm libreactor-2.0.0.tar.gz
