FROM amazonlinux:latest

RUN yum -y update && \
    yum -y install \
      vim \
      zip && rm -rf /var/cache/yum

# Create app directory and add app
ENV APP_HOME /app
ENV APP_SRC $APP_HOME/src
RUN mkdir $APP_HOME
ADD . $APP_HOME
