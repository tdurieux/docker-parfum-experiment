FROM python:latest

WORKDIR /jose
ADD . /jose

# RUN apk add --no-cache alpine-sdk git
RUN pip3 install --no-cache-dir -Ur requirements.txt

ENV NAME jose

CMD ["python3", "jose.py"]

