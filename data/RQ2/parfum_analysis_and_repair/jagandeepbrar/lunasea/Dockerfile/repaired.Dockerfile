# Build
FROM debian:latest as build

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:$PATH"
RUN apt-get update && apt-get install --no-install-recommends -y curl git wget unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
RUN flutter channel stable
RUN flutter upgrade

RUN mkdir /lunasea/
COPY . /lunasea/
WORKDIR /lunasea/
RUN flutter build web

# Runtime
FROM nginx:alpine
LABEL org.opencontainers.image.source="https://github.com/JagandeepBrar/LunaSea"
COPY --from=build /lunasea/build/web /usr/share/nginx/html
