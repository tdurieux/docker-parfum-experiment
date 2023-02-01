FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /home
RUN apt-get update && apt-get -y --no-install-recommends install g++ make git libsdl2-dev && rm -rf /var/lib/apt/lists/*;
COPY . .
CMD ["make","dist"]
