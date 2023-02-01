# This file is auto-generated from src/templates

FROM trzeci/emscripten:latest

RUN apt-get update -y && apt-get install --no-install-recommends -y autoconf libtool shtool autogen pkg-config && rm -rf /var/lib/apt/lists/*;