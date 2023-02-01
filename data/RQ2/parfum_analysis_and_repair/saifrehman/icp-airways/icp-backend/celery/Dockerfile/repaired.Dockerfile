FROM ubuntu:latest
RUN apt-get update -y && apt-get install --no-install-recommends -y python-pip python-dev build-essential && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/src/app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5671 5672
RUN chmod +x run.sh

ENTRYPOINT [ "./run.sh" ]