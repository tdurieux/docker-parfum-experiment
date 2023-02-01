FROM debian:buster
# debian@sha256:8414aa82208bc4c2761dc149df67e25c6b8a9380e5d8c4e7b5c84ca2d04bb244

LABEL maintainer="bookgin"

#RUN sed -i 's/deb.debian.org/debian.csie.ntu.edu.tw/g' /etc/apt/sources.list
RUN apt update -y

RUN apt install --no-install-recommends -y chromium && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y chromium-driver && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y xvfb && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

COPY --chown=redis:redis redis.conf /etc/redis/redis.conf
COPY default /etc/nginx/sites-available/default
RUN useradd --create-home --home-dir /home/user user
RUN mkdir /home/user/app

WORKDIR /home/user/app
RUN npm install redis && npm cache clean --force;
RUN npm install express && npm cache clean --force;
RUN npm install selenium-webdriver && npm cache clean --force;

CMD /home/user/app/run.sh
