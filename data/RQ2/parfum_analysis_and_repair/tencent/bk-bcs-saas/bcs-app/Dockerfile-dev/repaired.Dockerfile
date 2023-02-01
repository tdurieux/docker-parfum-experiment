FROM python:3.6.8-stretch
WORKDIR /data

ENV HELM_LINK=http://bkopen-1252002024.file.myqcloud.com/bcs/kubectl-helm.tar.gz
ENV HELM_BASE_DIR=/usr/local/helm
ENV HELM_BIN_DIR=/usr/local/helm/bin
RUN mkdir -p $HELM_BIN_DIR && curl -f -sL $HELM_LINK | tar xzf - -C $HELM_BIN_DIR && chmod a+x $HELM_BIN_DIR/*

ADD . .
RUN pip install --no-cache-dir -r requirements.txt