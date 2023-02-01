# docker build -t distrinet:1.1 .
FROM ubuntu:18.04
MAINTAINER Giuseppe Di Lena (giuseppedilena92@gmail.com)
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y software-properties-common vim build-essential python3.6 python3-pip git && rm -rf /var/lib/apt/lists/*;
# update pip
RUN python3.6 -m pip install pip --upgrade
WORKDIR /
RUN git clone https://github.com/Giuseppe1992/Distrinet
WORKDIR /Distrinet
ENV PYTHONPATH "${PYTHONPATH}:/Distrinet/mininet/mininet"
RUN pip install --no-cache-dir -r requirements.txt && python3.6 setup.py install
RUN mkdir -p ~/.aws && echo "[default]\naws_access_key_id=XXXXXXXXXXXXXXXX\naws_secret_access_key=YYYYYYYYYYYYYYYYYYYY">> ~/.aws/credentials
CMD /bin/bash
