FROM ubuntu:20.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git cmake wget python3 python3-pip && rm -rf /var/lib/apt/lists/*;

# python requirements
ADD ./requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --no-cache-dir -r /tmp/requirements.txt

# app
COPY . /app
WORKDIR /app

# entrypoint
ENTRYPOINT [ "/bin/bash" ]
CMD [ "/app/.docker/entrypoint.sh" ]
