FROM python:3.9.1


RUN apt-get update

RUN apt-get -y --no-install-recommends install python3-numpy && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install python3-pandas && rm -rf /var/lib/apt/lists/*;

RUN python -m pip install --upgrade pip

WORKDIR /app

COPY . /app

RUN python -m pip install Cython
RUN python -m pip install pysocks
RUN python -m pip install -r requirements.txt

# This is the port that WARden runs from
EXPOSE 5000

# Install Tor
RUN apt-get install --no-install-recommends -y tor && rm -rf /var/lib/apt/lists/*;

# These are Tor ports
EXPOSE 9050
EXPOSE 9150

ENTRYPOINT ["sh","/app/docker_launcher.sh"]
CMD [""]

