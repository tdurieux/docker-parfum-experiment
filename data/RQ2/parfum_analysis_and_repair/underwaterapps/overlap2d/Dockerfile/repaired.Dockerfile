FROM java:8-jdk
RUN apt-get update && apt-get install --no-install-recommends -qqy xvfb && rm -rf /var/lib/apt/lists/*;
ENV DISPLAY=:99.0
WORKDIR /root/overlap2d