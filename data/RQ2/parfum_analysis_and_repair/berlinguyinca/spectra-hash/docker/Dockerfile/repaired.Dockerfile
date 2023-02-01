###
#  this docker file creates a the complete image for deployment of the Splash id website and test framework
###

FROM openjdk:8-jre

RUN DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade

#update apt-get
RUN apt-get update -y

RUN apt-get install --no-install-recommends -y lynx mc vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install unzip curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends awstats -y libnet-ip-perl libgeo-ipfree-perl logrotate && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

####
# do the actual installation
####
RUN \

    echo "===> installing utilities" && \
    apt-get install --no-install-recommends -y \
      unzip \
      mc \
      openssh-server \
      vim \
      links2 \
      ant && rm -rf /var/lib/apt/lists/*;

ADD target/splash.jar /opt/splash.jar

RUN rm /etc/nginx/sites-enabled/default

#configure nginx logrotate
ADD nginx/logrotate /etc/logrotate.d/nginx
RUN chmod 644 /etc/logrotate.d/nginx

ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/client.conf /etc/nginx/sites-enabled/client.conf
ADD nginx/awtstats.conf /etc/awstats/awstats.client.conf


ADD src/run.sh /opt/run.sh

EXPOSE 80

CMD ["/bin/bash","/opt/run.sh"]
