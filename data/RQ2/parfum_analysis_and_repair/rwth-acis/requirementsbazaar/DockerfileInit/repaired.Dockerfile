FROM liquibase/liquibase:4.4.0

ADD reqbaz/src/main/resources/changelog.yaml reqbaz/src/main/resources/base-permissions.sql /liquibase/changelog/

CMD docker-entrypoint.sh --url=jdbc:postgresql://${HOST}:5432/reqbaz --username=${USERNAME} --password=${PASSWORD} --classpath=/liquibase/changelog --changeLogFile=changelog.yaml update