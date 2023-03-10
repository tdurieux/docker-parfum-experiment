FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y g++ git cmake libgtk-3-dev \
    libglvnd-dev libglu1-mesa-dev freeglut3-dev libasound2-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR ${DAPPER_SOURCE:-/source}
ENV DAPPER_OUTPUT build/bin
ENTRYPOINT ["sh", "-c", "cd build; cmake .. && make -j4"]
