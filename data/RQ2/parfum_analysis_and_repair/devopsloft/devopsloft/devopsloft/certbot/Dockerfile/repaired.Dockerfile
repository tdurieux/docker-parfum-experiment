FROM certbot/certbot

ARG ENVIRONMENT

COPY .env.$ENVIRONMENT .env

COPY ./devopsloft/certbot/generateCerts.py .
COPY ./devopsloft/certbot/init-letsencrypt.py .
COPY ./devopsloft/certbot/requirements.txt  .

RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT [ "python3" ]
CMD [ "./generateCerts.py", "--server_name", "localhost" ]