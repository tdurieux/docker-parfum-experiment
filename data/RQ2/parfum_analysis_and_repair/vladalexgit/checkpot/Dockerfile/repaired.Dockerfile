FROM python:3.6

RUN mkdir checkpot
COPY ./ checkpot/

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends -y mercurial nmap iptables libapparmor1 libdevmapper1.02.1 libseccomp2 && rm -rf /var/lib/apt/lists/*;

RUN wget https://download.docker.com/linux/debian/dists/stretch/pool/stable/amd64/docker-ce_17.03.2~ce-0~debian-stretch_amd64.deb
RUN apt-get install --no-install-recommends -y ./docker-ce_17.03.2~ce-0~debian-stretch_amd64.deb && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r checkpot/requirements.txt

CMD python checkpot/ci_automated_tests.py
