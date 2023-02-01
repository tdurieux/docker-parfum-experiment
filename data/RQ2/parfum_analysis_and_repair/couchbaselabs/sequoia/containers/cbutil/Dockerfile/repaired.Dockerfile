FROM ubuntu:16.04
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 16126D3A3E5C1192
RUN apt-get autoclean
RUN apt-get clean all
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean
RUN apt-get update
RUN apt-get upgrade -s
RUN apt-get install --no-install-recommends -y git python-pip curl tar && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential libssl-dev libffi-dev python-dev && rm -rf /var/lib/apt/lists/*;


RUN pip install --no-cache-dir httplib2
RUN pip install --no-cache-dir paramiko

COPY cbinit.py /cbinit.py

ENTRYPOINT ["python"]