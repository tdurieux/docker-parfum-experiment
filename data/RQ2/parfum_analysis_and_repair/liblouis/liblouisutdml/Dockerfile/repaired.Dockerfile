FROM liblouis/liblouis

# Fetch build dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    libxml2-dev \
   && rm -rf /var/lib/apt/lists/*

# compile and test liblouisutdml
ADD . /usr/src/liblouisutdml
WORKDIR /usr/src/liblouisutdml
RUN ./autogen.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-java-bindings \
    && make check \
    && make install \
    && ldconfig

