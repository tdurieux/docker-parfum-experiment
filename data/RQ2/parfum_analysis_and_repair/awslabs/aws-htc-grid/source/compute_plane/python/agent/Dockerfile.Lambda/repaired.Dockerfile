FROM python:3.7.7-slim-buster

RUN apt-get update ; apt-get install --no-install-recommends -y binutils; rm -rf /var/lib/apt/lists/*; apt-get install --no-install-recommends -y procps

RUN mkdir -p /dist
RUN mkdir -p /app/agent

COPY ./dist/* /dist/
COPY ./source/compute_plane/python/agent/requirements.txt /app/agent/

WORKDIR /app/agent

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app/agent
ADD ./source/compute_plane/python/agent/agent.py .


CMD [ "python" , "./agent.py"]


