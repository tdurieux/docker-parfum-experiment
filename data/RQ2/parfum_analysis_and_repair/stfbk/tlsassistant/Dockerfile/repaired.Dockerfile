#TO BUILD: docker build -t tlsassistant .
#TO RUN: docker run -t tlsassistant -s example.com

#NOTE: any output file (html and png) will be created within the tlsassistant/Report folder

FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y git python3-dev python3-pip sudo && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata keyboard-configuration && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/stfbk/tlsassistant.git

WORKDIR "/tlsassistant"

RUN pip3 install --no-cache-dir -r requirements.txt

ENV TLSA_IN_A_DOCKER_CONTAINER Yes

RUN python3 install.py -v


ENTRYPOINT ["python3", "run.py"]