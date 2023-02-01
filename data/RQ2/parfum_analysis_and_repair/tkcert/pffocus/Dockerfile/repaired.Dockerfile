FROM python:3-alpine

COPY ./ /app
WORKDIR /app

RUN pip install --no-cache-dir -r /app/requirements.txt
RUN pip install --no-cache-dir /app

ENTRYPOINT ["/usr/local/bin/pfFocus-format"]
CMD ["-q", "-f", "md", "-i", "-", "-o", "-"]
