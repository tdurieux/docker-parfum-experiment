FROM infsec/monpoly:1.4.1
RUN apk add --no-cache --update python3=3.9.5-r2 py3-pip py3-psutil=5.8.0-r1
WORKDIR /work
COPY . /work
RUN pip3 install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python3", "main.py"]
