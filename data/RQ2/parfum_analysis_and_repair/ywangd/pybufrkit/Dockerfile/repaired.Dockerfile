FROM pypy:2

RUN pip install --no-cache-dir six bitstring
COPY pybufrkit /opt/app/pybufrkit
ENV PYTHONPATH=/opt/app

ENTRYPOINT ["pypy", "-m", "pybufrkit"]

