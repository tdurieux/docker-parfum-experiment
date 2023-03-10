FROM python:2

ENV DJANGO_STATIC_DIR "/usr/src/FIR/static"

RUN mkdir -p /usr/src  && \
    apt-get update && apt-get install --no-install-recommends -y netcat && \
    pip install --no-cache-dir \
        mysql-python \
        psycopg2 \
        django-djembe \
    && \
    cd /usr/src && \
    git clone "https://github.com/certsocietegenerale/FIR.git" && rm -rf /usr/src && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/FIR

COPY ./entrypoint.sh .
COPY ./set_default_data.sh .

RUN mkdir -p "${DJANGO_STATIC_DIR}" && \
    chmod u+x "$(pwd)/entrypoint.sh" && \
    chmod u+x "$(pwd)/set_default_data.sh" && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir -r fir_email/requirements_smime.txt

VOLUME ["/usr/src/FIR/static"]

EXPOSE 8000

CMD ["./entrypoint.sh"]
