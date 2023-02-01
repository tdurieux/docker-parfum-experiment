FROM python:slim

RUN apt-get update && apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN pip install --no-cache-dir octohatrack

ENTRYPOINT ["octohatrack"]
CMD ["-h"]

