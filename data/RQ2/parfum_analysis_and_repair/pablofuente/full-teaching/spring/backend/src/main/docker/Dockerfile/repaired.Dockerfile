FROM java:8

## Add the init script to the image
ADD init.sh init.sh
RUN chmod +x /init.sh

## Add the wait script to the image
ADD wait.sh wait.sh
RUN chmod +x /wait.sh

RUN apt-get update && apt-get install -y --no-install-recommends netcat-openbsd && rm -rf /var/lib/apt/lists/*;

ADD full-teaching-0.5-SNAPSHOT.war app.jar
RUN bash -c 'touch /app.jar'

EXPOSE 5000

CMD /wait.sh && /init.sh
