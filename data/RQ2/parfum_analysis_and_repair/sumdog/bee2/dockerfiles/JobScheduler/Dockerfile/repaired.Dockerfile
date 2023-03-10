FROM alpine
MAINTAINER sumit@penguindreams.org

RUN apk --update --no-cache add python3 docker dcron

ADD scheduler.py /scheduler.py
RUN chmod 700 /scheduler.py

CMD /scheduler.py
