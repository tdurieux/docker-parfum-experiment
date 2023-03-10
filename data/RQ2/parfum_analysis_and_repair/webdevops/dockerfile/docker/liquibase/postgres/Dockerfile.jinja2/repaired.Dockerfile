{{ docker.fromOfficial("openjdk", "8") }}

{{ docker.version() }}

{{ environment.liquibase('3.6.3', 'org.postgresql.Driver', '/usr/share/java/postgresql.jar') }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ liquibase.postgres() }}

{{ docker.workdir("/liquibase") }}
{{ docker.entrypoint("/entrypoint") }}