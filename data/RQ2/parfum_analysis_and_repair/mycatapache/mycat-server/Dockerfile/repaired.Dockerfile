FROM docker.io/adoptopenjdk/openjdk8:latest

ADD http://dl.mycat.io/1.6.6.1/Mycat-server-1.6.6.1-release-20180908155252-linux.tar.gz /usr/local
RUN cd /usr/local && tar -zxvf Mycat-server-1.6.6.1-release-20180908155252-linux.tar.gz && ls -lna && rm Mycat-server-1.6.6.1-release-20180908155252-linux.tar.gz

VOLUME /usr/local/mycat/conf
VOLUME /usr/local/mycat/logs

EXPOSE 8066 9066

CMD ["/usr/local/mycat/bin/mycat", "console"]
