FROM python:3.9.4-slim-buster
ARG APP_TAR
RUN adduser --disabled-password --gecos '' app
RUN apt-get update --yes && apt-get install --yes --no-install-recommends binutils=2.31.1-16 && \
    apt-get install --yes --no-install-recommends nano=3.2-3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /app
RUN mkdir -p /app/yanom && chown app /app/yanom && mkdir -p /app/yanom/data &&  chown app /app/yanom/data
RUN pip install --no-cache-dir pyinstaller
COPY --chown=app:app . .
RUN pip install --no-cache-dir -r requirements.txt
COPY --chown=app:app dockerfiles/yanom-dev-deb10-slim-buster/yanom.spec /app/src/
WORKDIR /app/src
RUN rm -rf /app/src/dist && rm -rf /app/src/build && \
    pyinstaller yanom.spec  && \
    cp /app/src/dist/yanom /app/yanom/ && \
    cp /app/src/config.ini /app/yanom && \
    chown -R app /app/yanom
WORKDIR /app
RUN tar -zcvf $APP_TAR yanom
USER app
CMD ["bash"]