FROM bernddoser/docker-devel-cpp:ubuntu-16.04

LABEL maintainer="Bernd Doser <bernd.doser@braintwister.eu>"

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    curl \
    libgtk2.0-0 \
    make \
    openjdk-8-jdk \
    python3-pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip \
 && pip3 install --no-cache-dir -I pyyaml==3.12

ENV DOWNLOAD_URL http://download.eclipse.org/technology/epp/downloads/release/oxygen/2/eclipse-java-oxygen-2-linux-gtk-x86_64.tar.gz
ENV INSTALLATION_DIR /usr/local

RUN curl -f -L "$DOWNLOAD_URL" | tar xz -C $INSTALLATION_DIR

# Install plugins
ADD install_plugins.py plugins.yml /
RUN ./install_plugins.py

CMD $INSTALLATION_DIR/eclipse/eclipse
