FROM python:3.8

RUN apt update \
    && apt install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir gmpy

RUN useradd -M -s /bin/false boggart

RUN mkdir -p /var/boggart/

WORKDIR /var/boggart/

COPY boggart.py flag.txt ./

USER boggart

ENTRYPOINT socat TCP-LISTEN:31337,reuseaddr,fork EXEC:"python -u boggart.py"
