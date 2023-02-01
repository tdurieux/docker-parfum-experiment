FROM python:3.7-alpine

# Build dependencies
RUN apk add --no-cache build-base gcc

# Layer caching
COPY requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt

COPY . /EvilOSX
WORKDIR /EvilOSX

CMD ["python", "start.py"]
