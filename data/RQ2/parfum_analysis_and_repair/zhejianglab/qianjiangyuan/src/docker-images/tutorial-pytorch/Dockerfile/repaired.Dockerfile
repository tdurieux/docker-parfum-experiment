#FROM ubuntu:16.04
FROM pytorch/pytorch:v0.2
MAINTAINER Jin Li <jinlmsft@hotmail.com>

RUN umask 022
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install \
      vim \
      wget \
      curl \
      jq \
      gawk \
      openssh-client \
      git \
      rsync \
      sudo && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        vim \
        locales \
        curl \
        apt-transport-https \
        screen && rm -rf /var/lib/apt/lists/*;

# netcore 2.0
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-get update
RUN apt-get install --no-install-recommends -y dotnet-sdk-2.0.0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y aspnetcore-store-2.0.0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get update -y && \
    apt-get -y --no-install-recommends install apache2 libapache2-mod-wsgi-py3 && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /var/www/html/

RUN apt-get update -y && apt-get install --no-install-recommends -y python3-pycurl locales ssh-askpass && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir flask flask.restful
RUN pip install --no-cache-dir bs4 requests
RUN pip install --no-cache-dir -U flask-cors
RUN pip install --no-cache-dir opencv-python pandas jupyter matplotlib

RUN apt-get update -y && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
# RUN sudo npm install bower -g


ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

#EXPOSE 80
#EXPOSE 5000

RUN chmod -R 755 /var/www/html/

COPY wwwroot /var/www/html

RUN rm /etc/apache2/mods-enabled/mpm_*
COPY mpm_prefork.conf /etc/apache2/mods-available/mpm_prefork.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ports.conf /etc/apache2/ports.conf
RUN ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf
RUN ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load
COPY bingserver-restfulapi.wsgi /wsgi/bingserver-restfulapi.wsgi
ADD RestAPI /BingServer/src/RestAPI

#ADD utils /BingServer/src/RestAPI/utils
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
ADD run.sh /run.sh
RUN chmod +x /run.sh

RUN apt-get update -y && apt-get install --no-install-recommends -y openssh-server sudo && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /var/log/apache2
RUN chmod 0777 /var/log/apache2
RUN chmod -R 0777 /root

# RUN apt-get update -y && apt-get install ssh-askpass rssh molly-guard ufw monkeysphere python3-ndg-httpsclient -y

ENV LD_LIBRARY_PATH /usr/local/nvidia/lib64/

EXPOSE 1380 180
ADD RecogServer /RecogServer

#Telemetry
#--------------
#The .NET Core tools collect usage data in order to improve your experience. The data is anonymous and does not include command-line arguments. The data is collected by Microsoft and shared with the community.
#You can opt out of telemetry by setting a DOTNET_CLI_TELEMETRY_OPTOUT environment variable to 1 using your favorite shell.
#You can read more about .NET Core tools telemetry @ https://aka.ms/dotnet-cli-telemetry.
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1
#WORKDIR /var/www/html
#RUN bower --allow-root install ng-file-upload --save

# Need to run privileged mode
# python /root/certificate-service/genkey-restapi.py &&

# CMD /bin/bash -c "service apache2 start && sleep infinity"

CMD /bin/bash -c /run.sh
