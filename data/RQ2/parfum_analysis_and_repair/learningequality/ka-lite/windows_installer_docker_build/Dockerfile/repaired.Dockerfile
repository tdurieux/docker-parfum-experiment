FROM ubuntu:xenial

RUN apt-get -y update

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y --no-install-recommends git wget ca-certificates sudo software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y ppa:ubuntu-wine/ppa && apt-get -y update && apt-get install -y --no-install-recommends --assume-yes wine && rm -rf /var/lib/apt/lists/*;

COPY . /kalite

RUN mkdir /installer/

# Build KA-Lite windows installer.
CMD cd /kalite/ka-lite-installers/windows \
    && WHL_FILE=$(basename $(find . -name ka_lite-*.whl)) \
    && export KALITE_BUILD_VERSION=$(echo $WHL_FILE | cut -d'-' -f 2) \
    && wine inno-compiler/ISCC.exe installer-source/KaliteSetupScript.iss \
    && cp /kalite/ka-lite-installers/windows/KALiteSetup-$KALITE_BUILD_VERSION.exe /installer/
