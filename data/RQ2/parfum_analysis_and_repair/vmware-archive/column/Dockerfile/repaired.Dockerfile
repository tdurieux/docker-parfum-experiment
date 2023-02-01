FROM ubuntu:xenial
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    python-pip \
    python-dev \
    build-essential \
    libssl-dev \
    libffi-dev && rm -rf /var/lib/apt/lists/*;
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt \
&& python setup.py install \
&& mkdir -p /var/log/column \
&& touch /var/log/column/column.log
COPY ./etc/column/column-docker.conf /etc/column/column.conf
EXPOSE 48620
ENTRYPOINT ["python"]
CMD ["column/api/run.py"]
