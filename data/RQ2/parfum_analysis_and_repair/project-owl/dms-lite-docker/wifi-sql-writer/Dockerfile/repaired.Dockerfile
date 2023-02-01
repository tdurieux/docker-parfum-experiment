FROM python:slim-bullseye

RUN apt update && apt upgrade -y && apt install --no-install-recommends -y gcc libmariadb-dev libmariadb3 && rm -rf /var/lib/apt/lists/*;

# Copies files from the host into the container
COPY wifi_sqlwriter.py /

# Installs paho-MQTT and mariadb libraries for python
RUN pip3 install --no-cache-dir paho-mqtt mariadb

# Tells Docker to run the python code and where it is located
ENTRYPOINT [ "python3", "wifi_sqlwriter.py" ]
