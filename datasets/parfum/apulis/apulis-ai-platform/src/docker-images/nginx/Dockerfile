# FROM library/nginx:1.15.11
FROM nginx:1.18.0
MAINTAINER Jin Li <jinlmsft@hotmail.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        vim \
        python-dev \
        python-numpy \
        python-pip \
        python-yaml \
        locales \
        curl \
        apt-transport-https \
        ssh \
        software-properties-common \
        gnupg2 \
        pass \
        dirmngr

#RUN sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
#RUN apt-get install -y apt-transport-https
#RUN apt-get update
#RUN apt-get install -y dotnet-dev-1.0.4

# netcore 2.0
RUN pip install --upgrade pip; 

RUN pip install setuptools; 

RUN pip install flask
RUN pip install flask.restful

# No need on debian stretch
# RUN add-apt-repository ppa:certbot/certbot
RUN apt-get update -y && apt-get install -y certbot inotify-tools python-certbot-nginx # -t stretch-backports
RUN apt-get update -y && apt-get install -y --no-install-recommends python python-dev virtualenv python-virtualenv gcc libaugeas0 augeas-lenses libssl-dev openssl libffi-dev ca-certificates

WORKDIR /home
# RUN wget https://dl.eff.org/certbot-auto
# RUN chmod a+x certbot-auto


COPY auto-reload-nginx.sh /home/auto-reload-nginx.sh
COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx*.conf /etc/nginx/
RUN chmod +x /home/auto-reload-nginx.sh
RUN chmod +x /etc/nginx/conf.d/default.conf

RUN yes | apt-get install -y letsencrypt
# RUN letsencrypt certonly --webroot -w /usr/share/nginx -d dev.qjycloud.com
# RUN sudo service nginx reload