from ubuntu

LABEL maintainer "Cody De Arkand <cdearkland@vmware.com> and Grant Orchard (gorchard@vmware.com)"
LABEL description "Caspyr Image"

RUN apt update && apt install --no-install-recommends -y \
    git \
    python3.6 \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir requests

COPY caspyr /usr/local/lib/python3.6/dist-packages/caspyr

CMD ["/bin/sh"]

