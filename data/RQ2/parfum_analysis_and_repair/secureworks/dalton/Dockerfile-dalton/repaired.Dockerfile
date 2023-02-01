FROM python:3.9.0
MAINTAINER David Wharton

# wireshark needed for mergecap; statically compiled
#  mergecap would be smaller but doing this for now
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install wireshark-common \
    p7zip-full && rm -rf /var/lib/apt/lists/*;

# for development; not needed by the app
#RUN apt-get install -y less nano net-tools

WORKDIR /opt/dalton

COPY requirements.txt /opt/dalton/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY app /opt/dalton/app
COPY run.py /opt/dalton/run.py
COPY dalton.conf /opt/dalton/dalton.conf
COPY rulesets /opt/dalton/rulesets
COPY engine-configs /opt/dalton/engine-configs

CMD python /opt/dalton/run.py -c /opt/dalton/dalton.conf
