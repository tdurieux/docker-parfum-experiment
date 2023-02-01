FROM alpine:latest

RUN apk add --no-cache --update python3 py3-pip git

RUN git clone https://github.com/UnaPibaGeek/ctfr
WORKDIR ctfr
RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "ctfr.py"]
CMD ["-h"]
