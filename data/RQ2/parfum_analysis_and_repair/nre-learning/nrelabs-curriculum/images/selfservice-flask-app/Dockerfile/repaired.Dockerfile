FROM ubuntu:xenial
RUN apt-get update -y && apt-get install --no-install-recommends -y python-pip python-dev build-essential python3-pip python3-dev && rm -rf /var/lib/apt/lists/*;
COPY . /app
WORKDIR /app
RUN pip3 install --no-cache-dir -r /app/sample_app/requirements.txt
RUN python3 /app/setup.py install
ENTRYPOINT ["python3"]
CMD ["run_sample_app.py"]
