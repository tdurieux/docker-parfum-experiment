FROM python:3.9

RUN apt-get update && apt-get -y --no-install-recommends install python3-pip libglib2.0-dev libbluetooth-dev bluetooth && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir bluepy
RUN pip3 install --no-cache-dir requests
# pybluez wont compile with the newer version
RUN pip3 install --no-cache-dir --upgrade setuptools==57.5.0
RUN pip3 install --no-cache-dir pybluez
RUN pip3 install --no-cache-dir pycryptodomex
RUN pip3 install --no-cache-dir paho-mqtt

COPY . /app

ENTRYPOINT ["python3", "/app/LYWSD03MMC.py"]
