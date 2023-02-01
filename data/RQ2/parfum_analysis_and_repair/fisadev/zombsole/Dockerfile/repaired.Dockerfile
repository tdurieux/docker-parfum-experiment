FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;

# added before the full folder, so caching of pip installation
# isn't broke when cached of the full zombsole folder breaks
ADD requirements.txt /home/docker/requirements.txt
ADD isolation/requirements.txt /home/docker/isolation_requirements.txt

WORKDIR /home/docker
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r isolation_requirements.txt

# now add the rest of the folder
ADD . /home/docker/zombsole/
WORKDIR /home/docker/zombsole

EXPOSE 8000
CMD PYTHONPATH=. isolation/players_server.py
