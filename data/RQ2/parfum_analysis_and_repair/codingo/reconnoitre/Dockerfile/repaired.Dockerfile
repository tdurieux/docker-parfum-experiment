FROM python:3.7


RUN apt-get update && \
	apt-get install --no-install-recommends -y git nmap snmp wget nbtscan && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/codingo/Reconnoitre.git recon

WORKDIR /recon

RUN pip install --no-cache-dir -r requirements.txt && python setup.py install

ENTRYPOINT ["reconnoitre"]
