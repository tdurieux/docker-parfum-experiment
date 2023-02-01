FROM raspbian/stretch

RUN mkdir -p aditof-deps
WORKDIR aditof-deps

COPY ci/azure/lib.sh /aditof-deps
COPY ci/azure/setup_docker.sh /aditof-deps
ADD temp_deps/ /aditof-deps

RUN apt update
RUN apt install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;

RUN sudo apt install --no-install-recommends -y build-essential cmake python-dev python3-dev \
        libssl-dev git libgl1-mesa-dev libglfw3-dev && rm -rf /var/lib/apt/lists/*;

RUN chmod +x ./setup_docker.sh
RUN ./setup_docker.sh
