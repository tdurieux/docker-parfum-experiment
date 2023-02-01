FROM nodesource/jessie:6.3.1

RUN apt-get update && apt-get install --no-install-recommends -y lame sox curl && rm -rf /var/lib/apt/lists/*;

ADD package.json package.json 
RUN npm install && npm cache clean --force;
RUN npm install supervisor -g && npm cache clean --force;
ADD bot.js .

EXPOSE 3000

CMD ["supervisor","bot.js"]
