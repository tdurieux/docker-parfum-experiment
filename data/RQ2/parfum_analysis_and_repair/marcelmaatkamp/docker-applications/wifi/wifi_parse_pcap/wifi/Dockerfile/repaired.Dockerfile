FROM jfloff/alpine-python
RUN pip install --no-cache-dir pcap-parser
RUN apk update && apk add --no-cache tcpdump

CMD [ "tcpdump","-w-", "tcp port 80", "|", "parse_pcap" ]
