FROM visidata

RUN apk add --no-cache git
RUN pip install --no-cache-dir git+https://github.com/devottys/darkdraw.git@master
RUN sh -c "echo >>~/.visidatarc import darkdraw"

ENV TERM="xterm-256color"
ENTRYPOINT ["/opt/visidata/bin/vd", "-f", "ddw"]
