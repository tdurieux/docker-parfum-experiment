FROM mono
MAINTAINER Darren Cauthon <darren@cauthon.com>

RUN apt-get update && apt-get install --no-install-recommends -y wget git dos2unix vim zip && rm -rf /var/lib/apt/lists/*;

RUN nuget update -self

ENV MONO_THREADS_PER_CPU 2000

WORKDIR /

RUN git clone https://github.com/SparkPost/csharp-sparkpost.git

WORKDIR /csharp-sparkpost/src

ADD build_and_deploy.sh /csharp-sparkpost/src
RUN chmod 777 build_and_deploy.sh
RUN dos2unix build_and_deploy.sh

CMD /csharp-sparkpost/src/build_and_deploy.sh
