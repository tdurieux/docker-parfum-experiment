from curlimages/curl

COPY ./wait-for-server-healthz.sh /wait-for-server-healthz.sh
CMD /wait-for-server-healthz.sh