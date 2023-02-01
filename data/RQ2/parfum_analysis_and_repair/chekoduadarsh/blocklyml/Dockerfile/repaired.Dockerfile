FROM ubuntu:20.04
LABEL maintainer="Adarsh Chekodu <chekodu.adarsh@gmail.com>"
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN python3 -m pip install -r requirements.txt
COPY . /app
CMD ["python3", "./app.py" ]