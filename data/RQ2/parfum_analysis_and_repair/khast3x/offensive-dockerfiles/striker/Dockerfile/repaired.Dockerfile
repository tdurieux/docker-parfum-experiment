FROM alpine:edge

RUN apk --update add --no-cache python2 py2-requests py2-pip openssl ca-certificates
RUN apk --update --no-cache add --virtual build-dependencies python2-dev build-base wget git \
  && git clone https://github.com/UltimateHackers/Striker
WORKDIR Striker

#COPY requirements.txt .
RUN pip2 install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python2", "striker.py"]
CMD ["--help"]