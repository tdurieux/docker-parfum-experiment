#
# docker build -t appbase - < Docker.appbase
#
FROM debian:jessie

RUn apt-get update && apt-get install --no-install-recommends -yq sudo && rm -rf /var/lib/apt/lists/*;

# add our user
RUN useradd -G sudo,users dockerx
RUN echo "dockerx:docker" | chpasswd
