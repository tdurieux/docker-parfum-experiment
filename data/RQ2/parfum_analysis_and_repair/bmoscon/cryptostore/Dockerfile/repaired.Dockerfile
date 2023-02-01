FROM python:3.9-slim-bullseye

RUN apt update && apt install --no-install-recommends gcc git -y && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir cython
RUN pip install --no-cache-dir cryptofeed
RUN pip install --no-cache-dir aioredis
RUN pip install --no-cache-dir pymongo[srv]
RUN pip install --no-cache-dir motor
RUN pip install --no-cache-dir asyncpg

COPY cryptostore.py /cryptostore.py

CMD ["/cryptostore.py"]
ENTRYPOINT ["python"]
