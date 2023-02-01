FROM public.ecr.aws/lambda/python:3.9
RUN yum install -y zip && rm -rf /var/cache/yum
WORKDIR /lambda

ADD requirements.txt /tmp
RUN pip install --no-cache-dir --quiet -t /lambda -r /tmp/requirements.txt

ADD --chmod=ugo+rx src/ /lambda/

RUN python -m compileall -q /lambda

ARG ZIPFILE=lambda.zip
RUN zip --quiet -9r /${ZIPFILE}  .

FROM public.ecr.aws/lambda/python:3.9
COPY --from=0 /lambda /var/task

FROM scratch
ARG ZIPFILE
COPY --from=0 /${ZIPFILE} /

