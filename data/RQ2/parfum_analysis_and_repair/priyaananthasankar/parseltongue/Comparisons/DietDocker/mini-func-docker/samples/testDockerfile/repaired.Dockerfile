FROM python:3.6-alpine
RUN pip install --no-cache-dir pip==19.0 && \
    apk add --no-cache libc6-compat make automake gcc g++ subversion python3-dev freetype-dev openblas-dev
RUN pip3 install --no-cache-dir numpy scipy pandas
