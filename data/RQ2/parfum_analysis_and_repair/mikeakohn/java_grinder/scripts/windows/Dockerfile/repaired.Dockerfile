FROM ubuntu
RUN apt update && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends -y install git gcc make mingw-w64 zip vim openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
ADD build.sh /root/

