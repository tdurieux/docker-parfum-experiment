FROM ubuntu:14.04
MAINTAINER Matthieu Faure <mfaure@asqatasun.org>

# #### DISCLAIMER ###################################################################
#
#   This is a fat container, that is absolutly not compliant to Docker best-practices
#   https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/
#
#   Don't use it for production as all data are wiped out at reboot / rebuild
#   BUT for quick testing, that does the job :)
# ###################################################################################


RUN apt-get update && apt-get -y --no-install-recommends install software-properties-common && add-apt-repository --yes ppa:openjdk-r/ppa && apt-get update && \
    apt-get -y --no-install-recommends install openjdk-8-jdk && update-java-alternatives -s java-1.8.0-openjdk-amd64 && rm -rf /var/lib/apt/lists/*;

USER root
ENV WWWPORT="8080" \
    DATABASE_DB="asqatasun" \
    DATABASE_HOST="localhost" \
    DATABASE_USER="asqatasun" \
    DATABASE_PASSWD="asqaP4sswd" \
    TOMCAT_WEBAPP_DIR="/var/lib/tomcat7/webapps" \
    TOMCAT_USER="tomcat7" \
    ASQA_URL="http://localhost:8080/asqatasun/" \
    ASQA_ADMIN_EMAIL="admin@asqatasun.org" \
    ASQA_ADMIN_PASSWD="myAsqaPassword"  \
    ASQA_RELEASE="4.0.3"
    # ASQA_RELEASE="4.1.0"

EXPOSE $WWWPORT

WORKDIR /root

# ##########################################################
#
# Asqatasun installation
# cf http://doc.asqatasun.org/en/10_Install_doc/
#
# ##########################################################

# Add Asqatasun
# Install Asqatasun
RUN apt-get update                                 && \
     apt-get -y --no-install-recommends   \
                  install wget            \
                          curl            \
                          ca-certificates           && \
    cd /root/                                       && \
    wget https://github.com/Asqatasun/Asqatasun/releases/download/v${ASQA_RELEASE}/asqatasun-${ASQA_RELEASE}.i386.tar.gz && \
    tar xvfz asqatasun-${ASQA_RELEASE}.i386.tar.gz && \
    mv asqatasun*/ ./asqatasun/ && \
    cp ./asqatasun/install/xvfb . && \
    ./asqatasun/install/pre-requisites.sh && \
    service mysql start && \
    sleep 5 && \
    cd /root/asqatasun/ && \
    echo "yes\n" | ./install.sh  \
        --database-db $DATABASE_DB \
        --database-host $DATABASE_HOST \
        --database-user $DATABASE_USER \
        --database-passwd $DATABASE_PASSWD \
        --asqatasun-url $ASQA_URL \
        --tomcat-webapps $TOMCAT_WEBAPP_DIR \
        --tomcat-user $TOMCAT_USER \
        --asqa-admin-email $ASQA_ADMIN_EMAIL \
        --asqa-admin-passwd $ASQA_ADMIN_PASSWD \
        --firefox-esr-binary-path /opt/firefox/firefox \
        --display-port :99 && \
    rm -rvf  /root/asqatasun* && rm asqatasun-${ASQA_RELEASE}.i386.tar.gz && rm -rf /var/lib/apt/lists/*;


# Health Check of the Docker Container
HEALTHCHECK --timeout=3s    \
            --interval=10s  \
            CMD curl --fail http://localhost:8080/asqatasun/ || exit 1
            ######################################################################
            # doc: https://docs.docker.com/engine/reference/builder/#healthcheck
            # options:  --interval=DURATION (default: 30s)
            #           --timeout=DURATION (default: 30s)
            #           --retries=N (default: 3)
            # can be overridden at the command line 'docker run --health-cmd (...)'
            ######################################################################

CMD service mysql start && \
    sleep 5 && \
    service xvfb start && \
    echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> /etc/default/tomcat7 && \
    service tomcat7 start ; \
    tail -f /var/log/tomcat7/catalina.out \
         /var/log/asqatasun/asqatasun.log
