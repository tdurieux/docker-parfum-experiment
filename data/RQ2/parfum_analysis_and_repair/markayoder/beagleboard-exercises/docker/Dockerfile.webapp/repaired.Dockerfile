FROM armhf/ubuntu
MAINTAINER Mark A. Yoder <Mark.A.Yoder@Rose-Hulman.edu>
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y -q python-all python-pip && rm -rf /var/lib/apt/lists/*;
ADD ./webapp/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -qr /tmp/requirements.txt
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp
EXPOSE 5000
CMD ["python", "app.py"]

