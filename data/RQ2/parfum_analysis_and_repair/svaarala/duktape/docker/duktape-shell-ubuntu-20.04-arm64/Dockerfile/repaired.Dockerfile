FROM duktape-base-ubuntu-20.04-arm64:latest

COPY --chown=duktape:duktape run.sh .
RUN chmod 755 run.sh

CMD /work/run.sh