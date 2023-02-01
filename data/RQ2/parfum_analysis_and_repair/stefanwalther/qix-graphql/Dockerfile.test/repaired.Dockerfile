FROM stefanwalther/qix-graphql:latest

RUN npm config set loglevel warn
RUN npm install --quiet && npm cache clean --force;

COPY /test ./test/
COPY /.eslintrc.json ./.eslintrc.json
COPY /Makefile ./Makefile

RUN apk --no-cache add make grep git
