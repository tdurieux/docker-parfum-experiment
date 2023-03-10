FROM java:8
RUN mkdir -p /code/lib
WORKDIR /code
ARG JAR_FILE
VOLUME /root/.vorto
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/jessie-updates/d' /etc/apt/sources.list # Now archived
RUN apt-get -o Acquire::Check-Valid-Until=false update && apt-get install --no-install-recommends -y python3 python3-yaml wget && rm -rf /var/lib/apt/lists/*;
RUN wget -P /code/lib https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/2.3.0/mariadb-java-client-2.3.0.jar
ADD ./${JAR_FILE} /code/infomodelrepository.jar
ADD ./docker/scripts/run.py /code
ADD ./docker/config/application.yml /code/config/
ADD ./docker/config/vorto-repository-config-mysql.json /code/config/
ADD ./docker/scripts/wait-for-it.sh /code
RUN chmod +x wait-for-it.sh
CMD ["/bin/bash", "/code/wait-for-it.sh", "-t", "120", "db:3306",  "--", "/usr/bin/python3", "/code/run.py"]
EXPOSE 8080
