FROM bernddoser/docker-devel-cpp:ubuntu-16.04-cmake-3.10-gcc-7-conan-1.0-docker-17.12

LABEL maintainer="Bernd Doser <bernd.doser@braintwister.eu>"

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    curl \
    firefox \
    libgtk2.0-0 \
    make \
    python3-setuptools \
    openjdk-8-jdk \
    python3-pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip \
 && pip3 install --no-cache-dir -I pyyaml==3.12

ENV DOWNLOAD_URL http://download.eclipse.org/technology/epp/downloads/release/oxygen/2/eclipse-cpp-oxygen-2-linux-gtk-x86_64.tar.gz
ENV INSTALLATION_DIR /usr/local

RUN curl -f -L "$DOWNLOAD_URL" | tar xz -C $INSTALLATION_DIR

# Install plugins
ADD install_plugins.py plugins.yml /
RUN ./install_plugins.py

# Create eclipse user
RUN mkdir -p /home/eclipse \
 && groupadd -r eclipse \
 && useradd -r -g eclipse -d /home/eclipse -s /sbin/nologin -c "Docker image user" eclipse
RUN chown eclipse:eclipse /home/eclipse
RUN usermod -aG docker eclipse
USER eclipse
WORKDIR /home/eclipse

CMD $INSTALLATION_DIR/eclipse/eclipse
