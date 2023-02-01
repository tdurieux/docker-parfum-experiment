ARG BASE_IMAGE=meltano/meltano/base
FROM $BASE_IMAGE

CMD ['bash']

COPY ./ ./

WORKDIR /meltano/docs
RUN pwd && pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir poetry && poetry install
