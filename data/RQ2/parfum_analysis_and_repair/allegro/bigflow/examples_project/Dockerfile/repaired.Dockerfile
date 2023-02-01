FROM python:3.7
COPY ./dist /dist
RUN apt-get -y update && apt-get install --no-install-recommends -y libzbar-dev libc-dev musl-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pip==20.2.4
RUN for i in /dist/*.whl; do pip install --no-cache-dir $i --use-feature=2020-resolver; done