FROM alpine
RUN --mount=type=secret,id=mysecret,target=mysecret cat /mysecret
RUN cat /mysecret