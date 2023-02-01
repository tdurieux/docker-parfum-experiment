FROM python:3.8-slim-buster
WORKDIR /src/mosaic
COPY . .
RUN apt-get update -y \
	&& apt-get install --no-install-recommends -y build-essential \
	&& pip3 install --no-cache-dir -r requirements.txt \
	&& apt-get purge -y --auto-remove build-essential && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["python3", "runMOSAIC.py"]
