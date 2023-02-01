FROM gcc-build
RUN apt-get update -yqq && apt-get install --no-install-recommends -yqq libboost-dev libboost-system1.62-dev && rm -rf /var/lib/apt/lists/*;


