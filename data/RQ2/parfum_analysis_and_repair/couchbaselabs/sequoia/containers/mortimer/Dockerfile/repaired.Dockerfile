FROM ubuntu_python
COPY mortimer.tar .
RUN tar -xf mortimer.tar && rm mortimer.tar
WORKDIR mortimer
RUN pip install --no-cache-dir tornado requests
RUN apt-get -y --no-install-recommends install sshpass && rm -rf /var/lib/apt/lists/*;
COPY wait_for_collection.py .
COPY publish.sh .
