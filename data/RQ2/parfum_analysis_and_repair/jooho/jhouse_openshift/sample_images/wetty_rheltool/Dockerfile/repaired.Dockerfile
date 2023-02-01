FROM node:0.10.38
MAINTAINER Nathan LeClaire <nathan@docker.com>

ADD . /app
WORKDIR /app
RUN npm install && npm cache clean --force;
RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN useradd -d /home/term -m -s /bin/bash term
RUN echo 'term:term' | chpasswd

EXPOSE 3000

ENTRYPOINT ["node"]
CMD ["app.js", "-p", "3000"]
