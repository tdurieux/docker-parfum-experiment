FROM ubuntu:18.04

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends libpq-dev git cmake libgtk-3-dev libglvnd-dev libglu1-mesa-dev -y && rm -rf /var/lib/apt/lists/*;
COPY . /app

CMD sh ./docker_run.sh