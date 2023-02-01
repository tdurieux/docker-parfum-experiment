FROM python:2
RUN pip install --no-cache-dir docker==2.1.0 kubernetes==2.0.0 pycurl influxdb==4.0.0
WORKDIR "/root/"
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl
COPY *.py *.json /root/
CMD ["python","-u","maincontrol.py","-v"]
