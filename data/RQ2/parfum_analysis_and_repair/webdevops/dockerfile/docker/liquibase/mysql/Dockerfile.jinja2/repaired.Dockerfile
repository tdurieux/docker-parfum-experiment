{{ docker.fromOfficial("openjdk", "8") }}

{{ docker.version() }}

{{ environment.liquibase('3.6.3', 'org.mariadb.jdbc.Driver', '/usr/share/java/mariadb-java-client.jar') }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ liquibase.mysql() }}

{{ docker.workdir("/liquibase") }}
{{ docker.entrypoint("/entrypoint") }}