from gcc:12.1.0

run apt-get -y update
run apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
run apt-get -y --no-install-recommends install libboost-context-dev && rm -rf /var/lib/apt/lists/*;

run apt-get -y --no-install-recommends install time && rm -rf /var/lib/apt/lists/*; # for benchamrks

workdir /home

cmd echo "*** Welcome to cpp-effects container (gcc 12.1.0) ***"; bash

# sudo docker build -t cppeff .
# docker run -it --rm -v $(pwd):/home cppeff