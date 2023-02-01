FROM python:3.7-slim

RUN apt update && apt upgrade -y && \
    apt install --no-install-recommends -y \
        wget \
        libmagic1 \
        build-essential && rm -rf /var/lib/apt/lists/*;

WORKDIR /bot

COPY *.py /bot/
COPY *.yaml /bot/
COPY *.txt /bot/
COPY eno /bot/eno/

# download libolm3 from Ubuntu focal distribution
# https://packages.ubuntu.com/focal/libolm3
# https://packages.ubuntu.com/focal/libolm-dev
RUN wget https://mirrors.kernel.org/ubuntu/pool/universe/o/olm/libolm-dev_3.1.3+dfsg-2build2_amd64.deb
RUN wget https://mirrors.kernel.org/ubuntu/pool/universe/o/olm/libolm3_3.1.3+dfsg-2build2_amd64.deb
RUN dpkg -i ./*.deb
RUN pip install --no-cache-dir -r requirements.txt

# clean up apt cache and remove gcc
RUN apt purge -y build-essential && \
    apt autoremove -y && apt clean && \
    rm -rf /var/lib/apt/lists/*

CMD [ "python", "./main.py" ]
