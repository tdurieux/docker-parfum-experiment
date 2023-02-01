FROM alpine

RUN apk update && apk --update --no-cache add ruby

ADD client.rb .

CMD ["ruby", "client.rb"]
