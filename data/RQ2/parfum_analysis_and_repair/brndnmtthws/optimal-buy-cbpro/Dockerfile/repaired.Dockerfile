FROM python:3

WORKDIR /appsrc

COPY . .
RUN pip install --no-cache-dir . \
  && rm -rf /appsrc

ENTRYPOINT ["optimal-buy-cbpro"]
