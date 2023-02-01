FROM ubuntu_javabridge
MAINTAINER Lee Kamentsky,leek@broadinstitute.org

RUN apt-get install --no-install-recommends -y cython git && rm -rf /var/lib/apt/lists/*;

