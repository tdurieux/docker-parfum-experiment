FROM python:3-slim

RUN pip install --no-cache-dir xonsh && \
    pip install --no-cache-dir pyyaml && \
    pip install --no-cache-dir fn.py && \
    pip install --no-cache-dir click && \
    pip install --no-cache-dir mypy-lang

RUN mkdir -p /root/.config/xonsh/  && \
    echo "{}" > /root/.config/xonsh/config.json

CMD xonsh
