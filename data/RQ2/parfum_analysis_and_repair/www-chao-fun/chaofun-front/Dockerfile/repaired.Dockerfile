FROM nginx:latest

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime



WORKDIR /home/application/

COPY . /home/application/

RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y nodejs \
    npm && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN ls ./

RUN npm rebuild node-sass
RUN npm install && npm cache clean --force;
RUN npm run build
