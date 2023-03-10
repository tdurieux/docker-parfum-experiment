FROM ubuntu:20.04

# ...

ENV JVM /usr/local/opt/jvm
RUN mkdir -p "${JVM}"

COPY /jdk/jdk-7u80-linux-x64.tar.gz "${JVM}"
RUN tar -xzf "${JVM}/jdk-7u80-linux-x64.tar.gz" -C "${JVM}/" && rm "${JVM}/jdk-7u80-linux-x64.tar.gz"
RUN ln -s "${JVM}/jdk1.7.0_80" "${JVM}/jdk"

# ...