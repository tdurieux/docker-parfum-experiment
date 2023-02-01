FROM python:3
ENV PYTHONUNBUFFERED 1
RUN apt-get update && \
    apt-get install --no-install-recommends -y openjdk-8-jdk && \
    apt-get install --no-install-recommends -y ant && \
    apt-get clean; rm -rf /var/lib/apt/lists/*;
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f; rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME
RUN mkdir /backend
WORKDIR /backend
COPY requirements.txt /backend/
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8000
COPY . /backend/