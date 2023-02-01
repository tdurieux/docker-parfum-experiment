FROM ubuntu:18.04
LABEL maintainer="james@example.com"
ENV REFRESHED_AT 2016-06-01

RUN apt-get -qq update && apt-get -qq -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;

VOLUME [ "/var/lib/tomcat8/webapps/" ]
WORKDIR /var/lib/tomcat8/webapps/

ENTRYPOINT [ "wget" ]
CMD [ "--help" ]
