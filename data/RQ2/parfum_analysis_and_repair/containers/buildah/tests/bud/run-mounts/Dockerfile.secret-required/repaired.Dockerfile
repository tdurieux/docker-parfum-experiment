FROM alpine
RUN --mount=type=secret,id=mysecret,required=true cat /run/secrets/mysecret