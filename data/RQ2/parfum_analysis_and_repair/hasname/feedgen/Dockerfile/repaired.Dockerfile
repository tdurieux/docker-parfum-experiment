#
FROM python:3.9
ENV WORKDIR=/srv/feedgen.hasname.com
WORKDIR ${WORKDIR}
COPY . ${WORKDIR}
RUN pip install --no-cache-dir poetry && \
    poetry install
ENTRYPOINT ["./entrypoint.sh"]
