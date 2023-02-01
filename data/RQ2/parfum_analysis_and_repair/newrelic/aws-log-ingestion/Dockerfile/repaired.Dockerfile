FROM python:3.9
RUN apt-get update && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;

WORKDIR /build
COPY src/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt --target .
COPY src .
RUN zip -r /out.zip .

CMD ["/bin/sh"]