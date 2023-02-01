FROM quay.io/kubespray/kpm:build
#FROM alpine:3.3

ARG workdir=/opt
ARG with_tests=true
ENV WITH_TESTS ${with_tests}

RUN rm -rf $workdir && mkdir -p $workdir
ADD . $workdir
WORKDIR $workdir
RUN apk --no-cache --update add python py-pip openssl ca-certificates git
RUN apk --no-cache --update add --virtual build-dependencies python-dev build-base wget openssl-dev libffi-dev \
    && pip install --no-cache-dir pip -U \
    && pip install --no-cache-dir gunicorn -U \
    && pip install --no-cache-dir -e .

RUN if [ "$WITH_TESTS" = true ]; then \
      pip install --no-cache-dir -r requirements_dev.txt -U; \
    fi


CMD ["kpm"]
