FROM scratch

COPY ./my-app /my-app
COPY ./credentials.txt /credentials.txt

ENTRYPOINT [“/my-app”