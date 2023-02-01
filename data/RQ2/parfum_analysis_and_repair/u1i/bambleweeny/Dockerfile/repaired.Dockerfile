FROM alpine
MAINTAINER uli.hitzel@gmail.com

EXPOSE 8080

RUN apk update
RUN apk add --no-cache python2
RUN apk add --no-cache py-pip
RUN apk update
RUN apk add --no-cache redis
RUN mkdir /app
RUN mkdir /data
RUN pip install --no-cache-dir cherrypy bottle redis
COPY b9y.sh /app
RUN chmod a+rx /app/b9y.sh
COPY server.py /app/server.py
COPY bambleweeny.py /app/bambleweeny.py
COPY swagger.json /app/swagger.json
RUN chmod a+r /app/*

CMD ["/app/b9y.sh"]
