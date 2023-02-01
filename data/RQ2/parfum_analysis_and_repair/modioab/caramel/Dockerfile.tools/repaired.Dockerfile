FROM python:3.9-slim-buster as build
COPY [".", "/build"]
WORKDIR /wheel
RUN pip3 install --no-cache-dir wheel
RUN pip3 wheel --wheel-dir=/wheel /build

FROM python:3.9-slim-buster as install
COPY --from=build ["/wheel", "/wheel"]
ENV CARAMEL_INI="/etc/caramel/caramel.ini"
COPY ["minimal.ini", "${CARAMEL_INI}"]
RUN pip3 install --no-cache-dir --no-index --find-links=/wheel caramel
RUN rm -rf /wheel
