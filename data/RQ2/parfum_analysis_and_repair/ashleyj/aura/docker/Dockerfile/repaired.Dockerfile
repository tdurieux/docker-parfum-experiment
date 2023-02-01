FROM debian:jessie
RUN apt-get update && apt-get install --no-install-recommends -y build-essential gcc-multilib g++-multilib openjdk-7-jdk zlibc git cmake libcap-dev && rm -rf /var/lib/apt/lists/*;

