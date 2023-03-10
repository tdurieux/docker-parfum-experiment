FROM peterevans/vegeta:6.8.1
WORKDIR /app
COPY . .
COPY ./ops/Vegeta/vegeta.sh .
RUN apk update && apk add --no-cache jq && apk add --no-cache curl
RUN chmod +x ./vegeta.sh
CMD [ "./vegeta.sh" ]