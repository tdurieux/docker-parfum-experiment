FROM widukind/docker-base

ADD . /code/

WORKDIR /code/

RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir --no-deps -e .

