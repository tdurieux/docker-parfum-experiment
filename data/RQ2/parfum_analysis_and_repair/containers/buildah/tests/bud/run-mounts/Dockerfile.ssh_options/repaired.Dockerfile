FROM alpine

RUN --mount=type=ssh,id=default,dst=/dstsock,uid=1000,gid=1001,mode=0444  stat -c "%a" /dstsock; ls -n /dstsock