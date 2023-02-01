FROM debian:stable-slim as fetcher

RUN apt-get -y update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
# The 'OPENGROK_DOWNLOAD_LINK' will be replaced by docker.sh.
RUN curl -f -sSL -o opengrok.tar.gz OPENGROK_DOWNLOAD_LINK

FROM tomcat:9-jre8
MAINTAINER OpenGrok developers "opengrok-dev@yahoogroups.com"

# prepare OpenGrok binaries and directories
COPY --from=fetcher opengrok.tar.gz /opengrok.tar.gz
RUN mkdir -p /opengrok /var/opengrok/etc /opengrok/data /opengrok/src && \
    tar -zxvf /opengrok.tar.gz -C /opengrok --strip-components 1 && \
    rm -f /opengrok.tar.gz

# install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y git subversion mercurial unzip inotify-tools python3 python3-pip && \
    python3 -m pip install /opengrok/tools/opengrok-tools* && rm -rf /var/lib/apt/lists/*;
# compile and install universal-ctags
RUN apt-get install --no-install-recommends -y pkg-config autoconf build-essential && git clone https://github.com/universal-ctags/ctags /root/ctags && \
    cd /root/ctags && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && \
    apt-get remove -y autoconf build-essential && apt-get -y autoremove && apt-get -y autoclean && \
    cd /root && rm -rf /root/ctags && rm -rf /var/lib/apt/lists/*;

# environment variables
ENV SRC_ROOT /opengrok/src
ENV DATA_ROOT /opengrok/data
ENV OPENGROK_WEBAPP_CONTEXT /
ENV OPENGROK_TOMCAT_BASE /usr/local/tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV CATALINA_BASE /usr/local/tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV CATALINA_TMPDIR /usr/local/tomcat/temp
ENV JRE_HOME /usr
ENV CLASSPATH /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar


# custom deployment to / with redirect from /source
RUN rm -rf /usr/local/tomcat/webapps/* && \
    opengrok-deploy /opengrok/lib/source.war /usr/local/tomcat/webapps/ROOT.war && \
    mkdir "/usr/local/tomcat/webapps/source" && \
    echo '<% response.sendRedirect("/"); %>' > "/usr/local/tomcat/webapps/source/index.jsp"

# disable all file logging
ADD logging.properties /usr/local/tomcat/conf/logging.properties
RUN sed -i -e 's/Valve/Disabled/' /usr/local/tomcat/conf/server.xml

# add our scripts
ADD scripts /scripts
RUN chmod -R +x /scripts

# run
WORKDIR $CATALINA_HOME
EXPOSE 8080
CMD ["/scripts/start.sh"]
