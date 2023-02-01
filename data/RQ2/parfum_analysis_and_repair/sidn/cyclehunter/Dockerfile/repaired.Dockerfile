FROM pypy:3.7-slim

RUN pip install --no-cache-dir dnspython tqdm async_lru

COPY *.py /cyclehunter/

WORKDIR /cyclehunter
