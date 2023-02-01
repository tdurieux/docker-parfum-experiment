FROM ubuntu:16.04
MAINTAINER cl0und "cl0und@sycl0ver"
ENV SECRET_KEY zwrz#E!zR%sQt&Uo5PDXld%b9xXZi%84JsqPHBgCfh4g*ZXT@6eQVO4b#Ps2u9yy
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y inetutils-ping && rm -rf /var/lib/apt/lists/*;
RUN useradd -m -d /home/sycl0ver -s /bin/bash sycl0ver
RUN echo 'sycl0ver:Eec5TN9fruOOTp2G' | chpasswd
ADD flaskweb/requirements.txt /bb9fb6cb9bb458df093f9b50ca8d3737/requirements.txt
RUN pip3 install --no-cache-dir uwsgi
RUN pip3 install --no-cache-dir -r /bb9fb6cb9bb458df093f9b50ca8d3737/requirements.txt
RUN pip3 install --no-cache-dir flask
WORKDIR /bb9fb6cb9bb458df093f9b50ca8d3737