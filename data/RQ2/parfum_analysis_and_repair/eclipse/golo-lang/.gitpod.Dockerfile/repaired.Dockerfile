FROM ubuntu:latest

RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-utils && \
    apt install --no-install-recommends -y openjdk-8-jdk && \
    apt install --no-install-recommends -y maven && \
    apt install --no-install-recommends -y mercurial && \
    apt install --no-install-recommends -y git && \
    apt-get -y --no-install-recommends install locales && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set the GOLO_HOME and update the PATH
RUN echo "export GOLO_HOME=/workspace/golo-lang/build/install/golo" >> ~/.bashrc  && \
    echo "export PATH=\$PATH:\$GOLO_HOME/bin" >> ~/.bashrc
