FROM ubuntu:16.04
RUN apt-get update
RUN apt-get upgrade -s
RUN apt-get install --no-install-recommends -y git python-pip curl tar && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential libssl-dev libffi-dev python-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir httplib2 dnspython==1.11.1
COPY analyticsManager.py /analyticsManager.py

ENTRYPOINT ["python","analyticsManager.py"]