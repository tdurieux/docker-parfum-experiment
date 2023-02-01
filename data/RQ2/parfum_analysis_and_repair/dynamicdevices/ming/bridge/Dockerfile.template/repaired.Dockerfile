FROM balenalib/%%BALENA_MACHINE_NAME%%-alpine-python

RUN apk add --no-cache \
      python3 gcc libc-dev parted-dev python3-dev

COPY requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt

COPY . /app
WORKDIR /app

CMD ["python3", "-u", "main.py"]
#CMD ["python3", "-u", "sleep.py"]
