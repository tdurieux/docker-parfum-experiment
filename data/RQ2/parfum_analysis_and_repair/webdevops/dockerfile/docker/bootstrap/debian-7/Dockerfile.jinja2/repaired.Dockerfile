{{ baselayout.dockerStage() }}

{{ docker.fromOfficial("debian", "7") }}

{{ docker.version() }}

{{ environment.general() }}

{{ baselayout.copy() }}

RUN set -x \
    {{ bootstrap.debian('wheezy') }}