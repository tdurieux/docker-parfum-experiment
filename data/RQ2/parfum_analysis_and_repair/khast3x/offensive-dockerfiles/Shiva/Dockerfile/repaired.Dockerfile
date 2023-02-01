FROM alpine:latest

RUN apk add --no-cache --update python py-pip git

RUN git clone https://github.com/UltimateHackers/Shiva.git
WORKDIR Shiva
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python", "shiva.py"]
