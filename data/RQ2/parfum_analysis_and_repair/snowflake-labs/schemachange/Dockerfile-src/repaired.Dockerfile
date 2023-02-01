FROM python:3.9

WORKDIR /build

COPY schemachange /build/schemachange
COPY requirements.txt setup.py README.md /build/

RUN pip3 install --no-cache-dir --upgrade -r requirements.txt
RUN pip3 install --no-cache-dir --upgrade setuptools wheel
RUN python3 setup.py bdist_wheel


FROM python:3.9

COPY --from=0 /build/dist/schemachange-*-py3-none-any.whl /tmp/
RUN pip3 install --no-cache-dir /tmp/schemachange-*-py3-none-any.whl && rm /tmp/schemachange-*-py3-none-any.whl

ENTRYPOINT schemachange
