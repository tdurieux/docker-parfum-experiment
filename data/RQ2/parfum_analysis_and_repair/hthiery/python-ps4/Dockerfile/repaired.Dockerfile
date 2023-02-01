FROM python:3.6
MAINTAINER Henrik Nicolaisen <henrik@nicolaisen.co>

ENV PATH "$PATH:/usr/local/bin"

RUN apt-get update && apt-get install --no-install-recommends -y tcpdump net-tools && rm -rf /var/lib/apt/lists/*;

COPY . ps4

RUN cd ps4 && \
    python3 setup.py install --force

ENTRYPOINT [ "ps4-ctrl" ]
CMD [ "-h", "-v" ]

SHELL ["/bin/bash", "-c"]
