FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y python python-dev python-pip python-virtualenv python-opencv python-matplotlib imagemagick && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir SPARQLWrapper Pillow

# Define working directory.
WORKDIR /bmfaces
