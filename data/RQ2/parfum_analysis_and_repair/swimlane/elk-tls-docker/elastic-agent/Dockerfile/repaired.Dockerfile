ARG ELK_VERSION

FROM amd64/ubuntu:20.04

RUN apt-get update && \
    apt-get -y --no-install-recommends install sudo && \
    apt-get -y --no-install-recommends install python3-pip python3 && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir requests
RUN pip3 install --no-cache-dir PyYaml
RUN pip3 install --no-cache-dir elastic-agent-setup==0.0.11

ADD install.py /install.py
RUN chmod +x /install.py

CMD ["/install.py"]
ENTRYPOINT ["python3"]
