FROM debian

RUN apt-get update && apt-get -y --no-install-recommends install bats pulseaudio psmisc procps && rm -rf /var/lib/apt/lists/*;

COPY ./pulseaudio-control.bash ./tests.bats /
