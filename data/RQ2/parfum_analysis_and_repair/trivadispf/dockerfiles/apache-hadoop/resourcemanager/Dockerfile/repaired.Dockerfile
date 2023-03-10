FROM trivadis/apache-hadoop-base:2.0.0-hadoop2.7.7-java8

MAINTAINER Ivan Ermilov <ivan.s.ermilov@gmail.com>

HEALTHCHECK CMD [ curl -f https://localhost:8088/ || exit 1]

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8088

CMD ["/run.sh"]
