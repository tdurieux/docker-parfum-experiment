{{ baselayout.dockerStage() }}

{{ docker.fromOfficial("debian", "8") }}

{{ docker.version() }}

{{ environment.general() }}

{{ baselayout.copy() }}

RUN set -x \
    {{ bootstrap.debian('jessie') }}