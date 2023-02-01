# Basic problemtools docker image, containing problemtools and the
# "ICPC languages" (C, C++, Java, Python 2, Python 3, and Kotlin)
#
# Build requirements:
# - Kotlin must be available from the host file system under
#   artifacts/kotlin/kotlinc.zip

ARG PROBLEMTOOLS_VERSION=develop
FROM problemtools/minimal:${PROBLEMTOOLS_VERSION}

LABEL maintainer="austrin@kattis.com"

ENV DEBIAN_FRONTEND=noninteractive

# Install C++, Java, and PyPy 2/3 via their ppa repository
RUN apt update && \
    apt install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:pypy/ppa && \
    apt update && \
    apt install --no-install-recommends -y \
        g++ \
        openjdk-11-jdk \
        pypy \
        pypy3 && rm -rf /var/lib/apt/lists/*;

# Install Kotlin
WORKDIR /usr/local
COPY artifacts/kotlin/kotlinc.zip /tmp
RUN unzip /tmp/kotlinc.zip
RUN ln -s /usr/local/kotlinc/bin/* bin/

# Reconfigure problemtools:
# - Use PyPy for Python 2
# - Use PyPy for Python 3
# - Use /usr/local/bin rather than /usr/bin for Kotlin
RUN mkdir -p /etc/kattis/problemtools
RUN echo " \n\
python2: \n\
    name: 'Python 2 w/PyPy'\n\
    run: '/usr/bin/pypy \"{mainfile}\"'\n\
 \n\
python3: \n\
    name: 'Python 3 w/PyPy'\n\
    run: '/usr/bin/pypy3 \"{mainfile}\"'\n\
 \n\
kotlin: \n\
    compile: '/usr/local/bin/kotlinc -d {path}/ -- {files}' \n\
    run: '/usr/local/bin/kotlin -Dfile.encoding=UTF-8 -J-XX:+UseSerialGC -J-Xss64m -J-Xms{memlim}m -J-Xmx{memlim}m -cp {path}/ {Mainclass}Kt' " > /etc/kattis/problemtools/languages.yaml

WORKDIR /
