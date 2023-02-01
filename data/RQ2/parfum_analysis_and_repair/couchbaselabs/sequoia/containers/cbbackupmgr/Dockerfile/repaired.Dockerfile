FROM ubuntu:14.04
RUN apt-get update
RUN apt-get install --no-install-recommends -y git python-dev python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends build-essential libssl-dev libffi-dev python-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir paramiko


COPY cbbackupmerge.py /cbbackupmerge.py
COPY cbbackupcompact.py /cbbackupcompact.py

ENTRYPOINT ["python"]