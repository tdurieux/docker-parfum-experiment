FROM library/nginx:1.15.11
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
        dirmngr && rm -rf /var/lib/apt/lists/*;

#RUN sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
#RUN apt-get install -y apt-transport-https
#RUN apt-get update
#RUN apt-get install -y dotnet-dev-1.0.4

# netcore 2.0
RUN pip install --no-cache-dir --upgrade pip;

RUN pip install --no-cache-dir setuptools;

RUN pip install --no-cache-dir flask
RUN pip install --no-cache-dir flask.restful

# No need on debian stretch
# RUN add-apt-repository ppa:certbot/certbot
RUN apt-get update -y && apt-get install --no-install-recommends -y certbot inotify-tools python-certbot-nginx && rm -rf /var/lib/apt/lists/*;
RUN apt-get update -y && apt-get install -y --no-install-recommends python python-dev virtualenv python-virtualenv gcc libaugeas0 augeas-lenses libssl-dev openssl libffi-dev ca-certificates && rm -rf /var/lib/apt/lists/*;

WORKDIR /home
# RUN wget https://dl.eff.org/certbot-auto
# RUN chmod a+x certbot-auto


COPY auto-reload-nginx.sh /home/auto-reload-nginx.sh
COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx*.conf /etc/nginx/
RUN chmod +x /home/auto-reload-nginx.sh
RUN chmod +x /etc/nginx/conf.d/default.conf