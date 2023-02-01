FROM node:12

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
    libcairo2 \
    libjpeg-dev \
    libgif-dev \
    fonts-wqy-zenhei && rm -rf /var/lib/apt/lists/*;

EXPOSE 3000

WORKDIR /app
ADD . /app

RUN npm install && npm cache clean --force;

COPY ./fonts/font.woff /usr/share/fonts/
RUN fc-cache -fv

CMD bin/www
