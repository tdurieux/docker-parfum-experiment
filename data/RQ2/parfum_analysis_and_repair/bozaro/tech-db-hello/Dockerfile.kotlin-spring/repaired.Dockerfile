FROM ubuntu:16.04

#
# Этот файл является почти полной копией Dockerfile.java-spring
#
MAINTAINER Nikita Kulikov

# Обвновление списка пакетов
RUN apt-get -y update

#
# Установка postgresql
#
ENV PGVER 9.5
RUN apt-get install --no-install-recommends -y postgresql-$PGVER && rm -rf /var/lib/apt/lists/*;

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-$PGVER`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker &&\
    /etc/init.d/postgresql stop

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/$PGVER/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/$PGVER/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/$PGVER/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Back to the root user
USER root

#
# Сборка проекта
#

# Установка JDK
RUN apt-get install --no-install-recommends -y openjdk-8-jdk-headless && rm -rf /var/lib/apt/lists/*;

# Копируем исходный код в Docker-контейнер
ENV WORK /opt/tech-db-hello
ADD kotlin-spring/ $WORK/kotlin-spring/
ADD common/ $WORK/common/

# Собираем и устанавливаем пакет
WORKDIR $WORK/kotlin-spring
RUN ./gradlew assemble

# Объявлем порт сервера
EXPOSE 5000

#
# Запускаем PostgreSQL и сервер
#
CMD service postgresql start &&\
    java -Xmx300M -Xmx300M -jar $WORK/kotlin-spring/build/libs/kotlin-spring.jar --database=jdbc:postgresql://localhost/docker --username=docker --password=docker
