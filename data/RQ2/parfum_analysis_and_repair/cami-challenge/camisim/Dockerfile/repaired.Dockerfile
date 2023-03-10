FROM ubuntu:20.04

RUN apt update && apt install --no-install-recommends -y python3 python3-pip perl libncursesw5 && rm -rf /var/lib/apt/lists/*;
RUN perl -MCPAN -e 'install XML::Simple'
ADD requirements.txt /requirements.txt
RUN cat requirements.txt | xargs -n 1 pip install
ADD *.py /usr/local/bin/
ADD scripts /usr/local/bin/scripts
ADD tools /usr/local/bin/tools
ADD defaults /usr/local/bin/defaults
WORKDIR /usr/local/bin
ENTRYPOINT ["python3"]
