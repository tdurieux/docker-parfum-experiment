FROM python:3.8
RUN apt-get update
RUN mkdir /work
WORKDIR /work
COPY requirements.txt /work
COPY src/ /work
RUN pip install --no-cache-dir -r requirements.txt
CMD ./run.sh