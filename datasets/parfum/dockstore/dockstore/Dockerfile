FROM eclipse-temurin:17.0.3_7-jdk-focal

# wipe them out, all of them, to reduce CVEs
RUN apt-get purge -y -- *python*  && apt-get -y autoremove

# Update the APT cache
# prepare for Java download
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends
# note locale settings seem redundant, temurin already has en_US.UTF-8 set
#    locales \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/* \
#    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
# ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# copy the jar not ending in 's', to make sure we get don't get the one ending in 'sources'
COPY dockstore-webservice/target/dockstore-webservice*[^s].jar /home

RUN mkdir /dockstore_logs && chmod a+rx /dockstore_logs

CMD ["/home/init_webservice.sh"]

