FROM tensorflow/tensorflow:latest
RUN apt-get -y update && apt-get -y --no-install-recommends install git vim && rm -rf /var/lib/apt/lists/*;
COPY setup.sh /setup.sh
