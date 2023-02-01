FROM microsoft/dotnet:latest

RUN mkdir /build

COPY build/linux/install.dependencies.sh /build

RUN cd /build; ./install.dependencies.sh

COPY stylecop.json /build/stylecop.json

COPY tests /build/tests

COPY src /build/src

COPY build/linux/test.Magick.NET.sh /build

RUN cd /build; ./test.Magick.NET.sh
