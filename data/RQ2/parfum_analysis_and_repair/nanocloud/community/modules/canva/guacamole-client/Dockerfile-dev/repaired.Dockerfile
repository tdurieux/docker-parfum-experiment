FROM nanocloud/guacamole-client
MAINTAINER \
  Olivier Berthonneau <olivier.berthonneau@nanocloud.com>

RUN apt-get -y --no-install-recommends install inotify-tools && rm -rf /var/lib/apt/lists/*;
ENV JPDA_ADDRESS=8000

CMD ["sh", "-c", "mvn package && (catalina.sh jpda run &) ; while inotifywait -r -e modify -e moved_to ./src ; do mvn package && touch /usr/local/tomcat/webapps/guacamole.war ; done"]
