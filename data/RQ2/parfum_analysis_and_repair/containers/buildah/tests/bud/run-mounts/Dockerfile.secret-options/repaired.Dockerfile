FROM alpine
RUN --mount=type=secret,id=mysecret,dst=/mysecret,uid=1000,gid=1001,mode=0444 stat -c "%a" /mysecret ; ls -n /mysecret