FROM python:2.7-slim

RUN apt-get update && apt-get install --no-install-recommends -y git \
										python2.7-dev \
										python-pip \
										python-docutils \
										perl \
										nmap \
										sslscan && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt
RUN git clone https://github.com/golismero/golismero.git
COPY user.conf ~/.golismero/user.conf
WORKDIR golismero/
RUN pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir -r requirements_unix.txt && ln -s /opt/golismero/golismero.py /usr/bin/golismero
ENTRYPOINT ["python", "golismero.py"]
CMD ["--help"]