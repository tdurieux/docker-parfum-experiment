FROM alpine

RUN apk update && apk --update --no-cache add ruby

ADD server.rb .

CMD ["ruby", "server.rb"]
