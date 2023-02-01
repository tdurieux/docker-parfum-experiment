FROM python:2.7.9

RUN mkdir -p /usr/src/hamper && rm -rf /usr/src/hamper
WORKDIR /usr/src/hamper

ENV HAMPER_DB_DIR /var/lib/hamper
VOLUME $HAMPER_DB_DIR
ENV DATABASE_URL sqlite:///$HAMPER_DB_DIR/hamper.db

# helps with caching
COPY requirements.txt /usr/src/hamper/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/hamper
RUN pip install --no-cache-dir -e /usr/src/hamper

CMD ["hamper"]
