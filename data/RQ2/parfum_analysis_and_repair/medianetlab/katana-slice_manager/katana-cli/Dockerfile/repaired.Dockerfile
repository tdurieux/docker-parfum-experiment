FROM python:3.7.4-slim

ENV INSTALL_PATH /katana-cli
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY katana-cli/. .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir --editable .

CMD /bin/bash