FROM nginx:latest

ENV SHARE_PATH=/share
RUN mkdir $SHARE_PATH
WORKDIR $SHARE_PATH

# default.cof ζΈγζγ
COPY ./conf.d/default.conf /etc/nginx/conf.d/default.conf