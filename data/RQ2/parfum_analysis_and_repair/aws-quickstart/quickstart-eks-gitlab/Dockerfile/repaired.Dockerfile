FROM python:3.8-buster

RUN apt install -y --no-install-recommends gcc && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir taskcat --upgrade

WORKDIR /src
ENTRYPOINT ["taskcat"]
CMD ["-h"]