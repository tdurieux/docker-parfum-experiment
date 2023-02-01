FROM ubuntu:latest
#RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe">/etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends php5 php5-mysql php5-mhash -y && rm -rf /var/lib/apt/lists/*;
ADD . /app
