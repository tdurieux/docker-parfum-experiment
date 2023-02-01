FROM python:3.6
ADD . /src
WORKDIR /src
RUN pip install --no-cache-dir -r requirements.txt

