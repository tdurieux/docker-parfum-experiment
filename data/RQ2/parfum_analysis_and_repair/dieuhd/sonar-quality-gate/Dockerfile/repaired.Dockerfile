FROM sonarsource/sonar-scanner-cli:4.6

ENV WORKDIR=/app

RUN mkdir /app/
COPY . /app/
WORKDIR /app

RUN npm install && npm cache clean --force;
RUN npm run build
RUN npm i -g && npm cache clean --force;
RUN rm -rf src

CMD sonar-scanner