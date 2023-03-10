FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
# 18.04 includes 2.17 but github requires 2.18+ to support submodules.
RUN add-apt-repository ppa:git-core/ppa
ADD .github/workflows/install_dependencies_build.sh install_dependencies_build.sh
RUN bash install_dependencies_build.sh
ADD requirements.txt requirements.txt
RUN python3 -m pip install -r requirements.txt
