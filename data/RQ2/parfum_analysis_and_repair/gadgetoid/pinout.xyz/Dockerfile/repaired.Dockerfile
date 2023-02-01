FROM python:2.7-slim

COPY . ./

RUN apt-get update && \
	apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -r requirements.txt

CMD ["bash", "-c", "make serve LANG=en"]