FROM peterevans/vegeta:6.9
WORKDIR /app
COPY . .
COPY ./ops/Vegeta/vegeta.sh .
RUN apk update &&      apk add jq && apk add curl
RUN chmod +x ./vegeta.sh
CMD [ "./vegeta.sh" ]