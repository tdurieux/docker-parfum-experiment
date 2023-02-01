FROM debian:8


RUN mkdir build
WORKDIR /build

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y git g++ cmake libboost-all-dev libzmq3-dev libosmpbf-dev libpqxx3-dev libgoogle-perftools-dev libprotobuf-dev libproj-dev protobuf-compiler libgeos-c1 liblog4cplus-dev binutils && rm -rf /var/lib/apt/lists/*;

RUN git clone --branch=dev https://github.com/hove-io/navitia.git

WORKDIR /build/navitia

RUN sed -i 's,git\@github.com:\([^/]*\)/\(.*\).git,https://github.com/\1/\2,' .gitmodules
RUN git submodule update --init --recursive

#navitia will be compiled at the build of the image, it's useful for debugging purpose
ARG BUILD=0
ARG NB_PROC_TO_IGNORE=0
RUN if [ $BUILD -eq 1 ]; then cmake -DCMAKE_BUILD_TYPE=Release -DSKIP_TESTS=ON -DSTRIP_SYMBOLS=ON source && make -j$(nproc --ignore=$NB_PROC_TO_IGNORE); fi

WORKDIR /build

RUN apt-get update && apt-get install --no-install-recommends --fix-missing -y apt-transport-https ca-certificates curl gnupg2 software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt-get update && apt-get install --no-install-recommends -y docker-ce && rm -rf /var/lib/apt/lists/*;

COPY Dockerfile-jormungandr Dockerfile-jormungandr
COPY Dockerfile-kraken Dockerfile-kraken
COPY Dockerfile-tyr-beat Dockerfile-tyr-beat
COPY Dockerfile-tyr-worker Dockerfile-tyr-worker
COPY Dockerfile-tyr-web Dockerfile-tyr-web
COPY Dockerfile-instances-configurator Dockerfile-instances-configurator
COPY Dockerfile-mock-kraken Dockerfile-mock-kraken

RUN echo "**/*.a" > .dockerignore
RUN echo "**/CMakeFiles/*" >> .dockerignore
RUN echo "**/*.o" >> .dockerignore
RUN echo ".git" >> .dockerignore
RUN echo "**/CMakeFiles" >> .dockerignore
RUN echo "**/*.cpp" >> .dockerignore
RUN echo "**/*.h" >> .dockerignore
RUN echo "**/test" >> .dockerignore

COPY build.sh build.sh
COPY run_tyr_beat.sh run_tyr_beat.sh
COPY tyr_settings.py tyr_settings.py
COPY instances_configuration.sh instances_configuration.sh
COPY templates templates

ENTRYPOINT ["./build.sh"]

