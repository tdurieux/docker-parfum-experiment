FROM python:3
WORKDIR python-jamf
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir keyrings.alt
ENTRYPOINT /bin/bash