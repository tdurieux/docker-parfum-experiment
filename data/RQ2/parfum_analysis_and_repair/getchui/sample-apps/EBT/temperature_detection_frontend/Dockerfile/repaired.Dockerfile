FROM node:14.7.0-stretch

COPY ./frontend /frontend
COPY ./main.py /

RUN cd /frontend && npm install && npm audit fix && npm run-script build && cd .. && npm cache clean --force;

RUN apt-get update && apt-get -y --no-install-recommends install python3-pip && pip3 install --no-cache-dir flask SQLAlchemy SQLAlchemy-Utils jwt numpy && rm -rf /var/lib/apt/lists/*;

CMD ["/main.py"]
ENTRYPOINT ["python3"]