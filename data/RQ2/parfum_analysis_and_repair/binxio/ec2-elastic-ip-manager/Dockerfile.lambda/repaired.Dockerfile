FROM python:3.7
RUN apt-get update && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;
WORKDIR /lambda

ADD requirements.txt /tmp
RUN pip install --no-cache-dir -t /lambda -r /tmp/requirements.txt

ADD src/ /lambda/
RUN find /lambda -type d | xargs -n 1 -I {} chmod ugo+rx "{}" && \
    find /lambda -type f | xargs -n 1 -I {} chmod ugo+r "{}"

RUN python -m compileall -q /lambda

ARG ZIPFILE=lambda.zip
RUN zip --quiet -9r /${ZIPFILE}  .

FROM scratch
ARG ZIPFILE
COPY --from=0 /${ZIPFILE} /
