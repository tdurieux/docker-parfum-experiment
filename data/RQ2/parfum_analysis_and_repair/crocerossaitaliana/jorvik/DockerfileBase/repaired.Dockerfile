FROM alfioemanuele/jorvik-docker-base:latest

#FROM python:3.5
ENV PYTHONUNBUFFERED 1

ADD . /tmp
WORKDIR /tmp

# Installa tutti i requisiti Ubuntu
RUN apt-get update
RUN wget https://raw.githubusercontent.com/CroceRossaItaliana/jorvik-docker-base/2e0c524a41bcb86632930a02aa39009cf008a8b8/apt-dependencies.txt
RUN apt-get --assume-yes -y --no-install-recommends install `cat apt-dependencies.txt | grep -v "#" | xargs` && rm -rf /var/lib/apt/lists/*;
# actually not deleting the file, to fix
RUN rm apt-dependencies.txt
RUN apt-get install -y --no-install-recommends libgeos-c1v5 apt-get install libgeos-3.7.1 && rm -rf /var/lib/apt/lists/*;

ENV GEOS_LIBRARY_PATH /usr/lib/x86_64-linux-gnu

# Scarica e installa i requisiti PIP da CroceRossaItalian/jorvik (branch master)
RUN pip install --no-cache-dir -r https://raw.githubusercontent.com/CroceRossaItaliana/jorvik/master/requirements.txt


CMD ["ls -alh"]
