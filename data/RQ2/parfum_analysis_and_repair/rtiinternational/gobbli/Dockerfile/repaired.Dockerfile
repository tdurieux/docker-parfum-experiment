ARG PYTHON_VERSION=3.7
FROM python:${PYTHON_VERSION}

COPY ./setup.py ./meta.json ./requirements.txt ./README.md /code/
COPY ./docs/requirements.txt /code/docs/requirements.txt

WORKDIR /code
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -e '.[augment,tokenize,interactive]' \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir -r docs/requirements.txt

COPY ./ /code
