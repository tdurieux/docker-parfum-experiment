FROM ubuntu:precise

RUN apt-get update && apt-get install --no-install-recommends python-flask msgpack-python python-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir git+https://github.com/cocaine/cocaine-framework-python

ADD ./main.py /
ADD ./app.py /
