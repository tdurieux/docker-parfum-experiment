FROM trivadis/apache-spark-submit:3.0.0pv2-hadoop2.7

MAINTAINER Cecile Tonglet <cecile.tonglet@tenforce.com>
MAINTAINER Gezim Sejdiu <g.sejdiu@gmail.com>

# Enables apt to run from the new sources - Guido Schmutz 19.5.2019
RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

RUN apt-get-install apt-transport-https

RUN echo "deb https://dl.bintray.com/sbt/debian /" > /etc/apt/sources.list.d/sbt.list \
      && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823

RUN apt-get-install sbt

WORKDIR /app

# Pre-install base libraries
ADD build.sbt /app/
ADD plugins.sbt /app/project/
RUN sbt update

COPY template.sh /

ENV SPARK_APPLICATION_MAIN_CLASS Application

# Copy the build.sbt first, for separate dependency resolving and downloading
ONBUILD COPY build.sbt /app/
ONBUILD COPY project /app/project
ONBUILD RUN sbt update

# Copy the source code and build the application
ONBUILD COPY . /app
ONBUILD RUN sbt clean assembly

CMD ["/template.sh"]