FROM python:3.8-buster

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY ./scripts/* /usr/local/bin/
COPY . /app
WORKDIR /app

# The http port
EXPOSE 4242

CMD run
