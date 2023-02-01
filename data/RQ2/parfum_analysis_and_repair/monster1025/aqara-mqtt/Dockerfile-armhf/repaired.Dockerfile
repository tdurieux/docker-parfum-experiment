FROM arm32v7/python:slim

ENV LIBRARY_PATH=/lib:/usr/lib

ADD src/requirements.txt /
RUN apt-get update && apt-get install --no-install-recommends -y build-essential autoconf \
	&& pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r /requirements.txt \
	&& apt-get remove -y build-essential autoconf \
	&& apt-get autoremove -y \
   && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY src /app

CMD ["python3", "-u", "/app/main.py"]