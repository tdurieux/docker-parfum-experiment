FROM ubuntu:xenial

RUN apt update && apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN add-apt-repository -y ppa:beineri/opt-qt593-xenial

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y git curl make cmake lcov xvfb && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ruby g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y mesa-common-dev libglu1-mesa-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install coveralls-lcov

# Qt installation
RUN apt-get install --no-install-recommends -y qt59base qt59multimedia && rm -rf /var/lib/apt/lists/*;

# Go installation
RUN curl -f -sL -o /usr/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
RUN chmod +x /usr/bin/gimme
RUN gimme 1.6

# Qt environment variables
ARG QT_BASE_DIR=/opt/qt59
ENV QTDIR ${QT_BASE_DIR}
ENV PATH ${QT_BASE_DIR}/bin:${PATH}
ENV LD_LIBRARY_PATH ${QT_BASE_DIR}/lib/x86_64-linux-gnu:${QT_BASE_DIR}/lib:${LD_LIBRARY_PATH}
ENV PKG_CONFIG_PATH ${QT_BASE_DIR}/lib/pkgconfig:${PKG_CONFIG_PATH}

# Go environment variables
ENV GOROOT '/root/.gimme/versions/go1.6.linux.amd64'
ENV PATH "/root/.gimme/versions/go1.6.linux.amd64/bin:${PATH}"
