# docker build -t telminov/ansible-manager .
FROM ubuntu:16.04
LABEL maintainer "telminov@soft-way.biz"


RUN apt update && \
    apt install --no-install-recommends -y \
                    supervisor \
                    python3-pip npm && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN mkdir /var/log/ansible-manager/

COPY . /opt/ansible-manager
WORKDIR /opt/ansible-manager


RUN pip3 install --no-cache-dir -r requirements.txt
RUN npm install && npm cache clean --force;
RUN cp project/local_settings.sample.py project/local_settings.py

COPY supervisor/prod.conf /etc/supervisor/conf.d/ansible-manager.conf

EXPOSE 80
VOLUME /data/
VOLUME /conf/
VOLUME /static/

RUN rm -rf media; ln -s /data/media media;
