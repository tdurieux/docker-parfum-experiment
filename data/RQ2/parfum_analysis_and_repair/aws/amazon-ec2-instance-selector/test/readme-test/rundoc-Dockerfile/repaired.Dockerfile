FROM python:3


RUN pip3 install --no-cache-dir rundoc

RUN touch /bin/go && chmod +x /bin/go

CMD [ "rundoc" "--help" ]
