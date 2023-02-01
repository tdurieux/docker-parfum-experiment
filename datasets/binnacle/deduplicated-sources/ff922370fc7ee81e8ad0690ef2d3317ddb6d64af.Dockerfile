FROM ubuntu:18.04
LABEL maintainer="clewis@iqt.org"

RUN apt-get update && apt-get install -y dpkg
COPY installers/debian /installers/debian
ARG PKG_NAME=poseidon
RUN sed -i "s/Package: poseidon/Package: $PKG_NAME/g" installers/debian/*/DEBIAN/control
RUN dpkg-deb --build /installers/debian/poseidon-*
CMD ["sh", "-c", "[ -t 1 ] && exec bash || exec cat /installers/debian/*.deb"]]
