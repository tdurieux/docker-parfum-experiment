FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update

RUN apt install --no-install-recommends -y libglbinding2 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libglbinding-dev && rm -rf /var/lib/apt/lists/*;
