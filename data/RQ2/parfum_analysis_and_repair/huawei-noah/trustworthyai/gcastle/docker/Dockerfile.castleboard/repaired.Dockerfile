FROM python:3.7.6

RUN mkdir -p /github/workspace

COPY . /github/workspace

WORKDIR /github/workspace

RUN pip3 install --no-cache-dir --upgrade pip && \
    python3 -m pip install -r ./requirements.txt && \
    python3 -m pip install -r ./requirements_web.txt && \
    pip install --no-cache-dir torch >=1.9.0

CMD python3 web/main.py