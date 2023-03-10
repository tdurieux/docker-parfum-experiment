FROM fedora:24

# Get Java 8 (64-bit)
RUN dnf install -y java-1.8.0-openjdk-devel

# Get other build utils
RUN dnf install -y cmake wget tar make gcc-c++

# Select Java 8
RUN echo 1 | update-alternatives --config java
RUN echo 1 | update-alternatives --config javac

# Get modern ant
RUN yum install -y ant && rm -rf /var/cache/yum
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk

VOLUME /opt/djinni
CMD /opt/djinni/test-suite/java/docker/build_and_run_tests.sh

