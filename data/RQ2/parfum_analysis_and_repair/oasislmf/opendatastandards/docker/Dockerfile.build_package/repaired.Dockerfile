FROM python:3.8                                                                                                                             

RUN  mkdir /tmp/output && \
     mkdir /var/log/oasis

RUN pip install --no-cache-dir pandas pyarrow openpyxl click tox

WORKDIR /home
COPY ./docker/extract_spec.py /usr/local/bin/extract_spec.py
COPY . .


CMD ./docker/build_package.sh
#ENTRYPOINT ["/bin/bash", "-c", "/tmp/build_docs.sh \"$@\"", "--"]
