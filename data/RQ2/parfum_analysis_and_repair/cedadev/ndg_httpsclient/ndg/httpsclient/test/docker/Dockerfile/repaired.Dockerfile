FROM ubuntu:14.04
RUN apt-get -yqq update && apt-get -yqq --no-install-recommends install python-pip python-dev libffi-dev libxmlsec1-openssl libssl-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /app/
ADD . /app/
RUN pip install --no-cache-dir -e .
CMD ["python", "setup.py", "test"]
