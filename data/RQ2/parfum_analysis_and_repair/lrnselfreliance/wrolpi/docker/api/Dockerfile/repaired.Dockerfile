FROM python:3.8-buster
ENV DOCKER=true
WORKDIR /opt/wrolpi

# Update dependencies for the services install.
RUN apt update && apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*; # ffmpeg for Videos

RUN ffmpeg -version

# Install WROLPi
COPY main.py /opt/wrolpi/
COPY wrolpi /opt/wrolpi/wrolpi
COPY modules /opt/wrolpi/modules
COPY requirements.txt /opt/wrolpi/requirements.txt
RUN pip3 install --no-cache-dir -r /opt/wrolpi/requirements.txt

ENTRYPOINT [ "python3", "/opt/wrolpi/main.py"]
CMD ["api", "--host", "0.0.0.0" ]
