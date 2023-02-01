FROM ubuntu:20.04

MAINTAINER Patrowl.io "getsupport@patrowl.io"
LABEL Name="Nmap\ \(Patrowl engine\)" Version="1.0.0"

# Set the working directory
RUN mkdir -p /opt/patrowl-engines/nmap
RUN mkdir -p /opt/patrowl-engines/nmap/results
RUN mkdir -p /opt/patrowl-engines/nmap/logs
WORKDIR /opt/patrowl-engines/nmap

# Copy the current directory contents into the container at /
COPY __init__.py .
COPY engine-nmap.py .
COPY nmap.json.sample nmap.json
COPY requirements.txt .
COPY README.md .
COPY libs/ libs/

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y --no-install-recommends nmap python3 python3-pip python3-dev build-essential gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean autoclean \
  && apt-get autoremove --yes \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

# TCP port exposed by the container (NAT)
EXPOSE 5001
USER root

# Run app when the container launches
CMD ["gunicorn", "engine-nmap:app", "-b", "0.0.0.0:5001", "--access-logfile", "-"]
