FROM gw000/keras:2.1.4-py3

COPY *.py /app/
COPY err-traces-shuf.txt /app
COPY vectors-gensim.txt /app

CMD [ "T", "docker" ]
ENTRYPOINT [ "python3" ]