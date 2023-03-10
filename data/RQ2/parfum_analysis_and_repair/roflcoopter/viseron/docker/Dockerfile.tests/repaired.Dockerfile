ARG ARCH
ARG VISERON_VERSION
FROM roflcoopter/${ARCH}-viseron:${VISERON_VERSION}

WORKDIR /src

ENV VISERON_TESTS=true

ADD requirements_test.txt requirements_test.txt
RUN \
  pip3 install --no-cache-dir -r requirements_test.txt

COPY viseron /src/viseron/
COPY tests /src/tests/
