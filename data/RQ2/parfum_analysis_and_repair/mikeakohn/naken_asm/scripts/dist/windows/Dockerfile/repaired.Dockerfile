FROM ubuntu
RUN apt update && apt -y --no-install-recommends install git gcc make mingw-w64 zip vim && rm -rf /var/lib/apt/lists/*;
ADD build.sh /root/

