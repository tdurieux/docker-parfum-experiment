FROM node:15 as dist

ARG COMPILER_PARAM=""
ENV COMPILER_PARAM=$COMPILER_PARAM

RUN apt update
RUN apt -y --no-install-recommends install git apt-transport-https software-properties-common && rm -rf /var/lib/apt/lists/*;
#RUN echo "deb http://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
RUN apt-get update
RUN apt-get -y --no-install-recommends install openjdk-8-jre && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/sbt/sbt/releases/download/v1.5.0/sbt-1.5.0.tgz
RUN tar xzvf sbt-1.5.0.tgz -C /usr/share/ && rm sbt-1.5.0.tgz
RUN update-alternatives --install /usr/bin/sbt sbt /usr/share/sbt/bin/sbt 9999
#RUN apt-get -y install sbt openjdk-8-jre
#RUN RUN RUN, why not? :)

COPY . /
RUN sh /scripts/build.sh

FROM nginx:latest

COPY nginx-ide.conf /etc/nginx/conf.d/
COPY --from=dist /dist /usr/share/nginx/dist
RUN nginx -t
