FROM tatsushid/tinycore-python:2.7
WORKDIR /home/weave
ADD requirements.txt /home/weave/
RUN pip install --no-cache-dir -r /home/weave/requirements.txt
ADD echo.py /home/weave/
EXPOSE 5000
ENTRYPOINT ["python", "/home/weave/echo.py"]

ARG revision
LABEL maintainer="Weaveworks <help@weave.works>" \
      org.opencontainers.image.title="example-echo" \
      org.opencontainers.image.source="https://github.com/weaveworks/scope/tree/master/extras/example/echo" \
      org.opencontainers.image.revision="${revision}" \
      org.opencontainers.image.vendor="Weaveworks"
