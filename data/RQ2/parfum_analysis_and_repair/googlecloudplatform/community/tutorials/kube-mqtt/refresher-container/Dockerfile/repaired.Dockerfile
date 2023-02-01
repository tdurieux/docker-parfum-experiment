FROM python:3.7
RUN mkdir /install
WORKDIR /install
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -r /requirements.txt
COPY src /app
WORKDIR /app
CMD ["/usr/local/bin/python", "run_bridge.py"]