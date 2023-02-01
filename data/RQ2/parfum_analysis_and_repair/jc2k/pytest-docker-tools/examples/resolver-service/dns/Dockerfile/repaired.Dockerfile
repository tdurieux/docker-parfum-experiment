FROM alpine:3.7
RUN apk --no-cache add python3 && python3 -m ensurepip && pip3 install --no-cache-dir dnslib
COPY dns.py /dns.py
ENV PYTHONUNBUFFERED 1
CMD ["python3", "dns.py"]
