FROM python:3.6
RUN apt-get update && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;
WORKDIR /lambda

ADD requirements.txt /tmp
RUN pip install --no-cache-dir --quiet -t /lambda -r /tmp/requirements.txt && \
    find /lambda -type d -print0 | xargs -0 chmod ugo+rx && \
    find /lambda -type f -print0 | xargs -0 chmod ugo+r

ADD src/ /lambda/
RUN find /lambda -type d -print0 | xargs -0 chmod ugo+rx && \
    find /lambda -type f -print0 | xargs -0 chmod ugo+r

RUN python -m compileall -q /lambda

ARG ZIPFILE=lambda.zip
RUN zip --quiet -9r /${ZIPFILE}  .

FROM scratch
ARG ZIPFILE
COPY --from=0 /${ZIPFILE} /
