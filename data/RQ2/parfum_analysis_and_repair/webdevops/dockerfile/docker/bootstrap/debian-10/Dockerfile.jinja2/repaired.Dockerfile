{{ baselayout.dockerStage() }}

{{ docker.fromOfficial("debian", "buster") }}

{{ docker.version() }}

{{ environment.general() }}

{{ baselayout.copy() }}

RUN set -x \
    {{ bootstrap.debian('buster') }}