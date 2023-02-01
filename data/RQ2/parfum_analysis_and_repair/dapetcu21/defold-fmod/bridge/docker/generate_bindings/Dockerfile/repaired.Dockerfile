FROM python:3

RUN pip install --no-cache-dir pycparser jinja2

VOLUME [ "/bridge" ]
WORKDIR /bridge

ENTRYPOINT [ "python", "generate_bindings.py" ]