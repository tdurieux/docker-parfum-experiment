from gliacloud/base_images:django

run apt-get install --no-install-recommends python-software-properties software-properties-common python-software-properties -y && rm -rf /var/lib/apt/lists/*;

#RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list
#RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list
#RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && apt-get update && apt-get install -y curl dnsutils oracle-java8-installer ca-certificates

RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y swig unzip wget && rm -rf /var/lib/apt/lists/*;


RUN apt-get update \
    && apt-get install --no-install-recommends git zlib1g-dev file swig python2.7 python-dev python-pip python-mock -y \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -U protobuf==3.0.0b2 \
    && pip install --no-cache-dir asciitree \
    && pip install --no-cache-dir numpy \
    && wget https://github.com/bazelbuild/bazel/releases/download/0.4.3/bazel-0.4.3-installer-linux-x86_64.sh \
    && chmod +x bazel-0.4.3-installer-linux-x86_64.sh \
    && ./bazel-0.4.3-installer-linux-x86_64.sh \
    && apt-get autoremove && rm -rf /var/lib/apt/lists/*;

# install latest bazel
#run echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
#run curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
#run apt-get update && apt-get install -y bazel

run pip install --no-cache-dir virtualenv

add . /work
workdir /work
run python setup.py install
