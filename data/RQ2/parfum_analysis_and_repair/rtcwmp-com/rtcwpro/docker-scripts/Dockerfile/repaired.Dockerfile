FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y g++-multilib mingw-w64 make dos2unix zip && rm -rf /var/lib/apt/lists/*;
