FROM ubuntu
RUN apt-get update && apt-get -y upgrade && apt-get -y --no-install-recommends install python-twisted && rm -rf /var/lib/apt/lists/*;
EXPOSE 8000
ADD echoserv.py /server.py
CMD /server.py
