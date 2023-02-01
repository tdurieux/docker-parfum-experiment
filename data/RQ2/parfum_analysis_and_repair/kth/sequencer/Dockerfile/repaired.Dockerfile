# docker build -t ubuntu1604py36
FROM ubuntu:16.04

RUN apt-get update

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y --no-install-recommends install locales && rm -rf /var/lib/apt/lists/*;
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3.6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;


RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

RUN apt-get install --no-install-recommends -y python-software-properties && rm -rf /var/lib/apt/lists/*;
# RUN apt-get install -y default-jre
# RUN apt-get install -y default-jdk
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
ENV PATH="${PATH}:$JAVA_HOME/bin"

RUN apt-get install --no-install-recommends -y git maven nano unzip wget subversion sshpass curl && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 2

WORKDIR /SequenceR

COPY . /SequenceR

RUN pip3 install --no-cache-dir --upgrade pip==19.1
RUN /SequenceR/src/setup_env.sh
ENV data_path=/SequenceR/data
ENV OpenNMT_py=/SequenceR/src/lib/OpenNMT-py

RUN apt-get install --no-install-recommends -y libcam-pdf-perl && rm -rf /var/lib/apt/lists/*;
ENV PERL_MM_USE_DEFAULT 1

RUN git clone https://github.com/rjust/defects4j /SequenceR/src/lib/defects4j
RUN cpan App::cpanminus
RUN cpanm --installdeps /SequenceR/src/lib/defects4j/
RUN /SequenceR/src/lib/defects4j/init.sh
ENV PATH="${PATH}:/SequenceR/src/lib/defects4j/framework/bin"
