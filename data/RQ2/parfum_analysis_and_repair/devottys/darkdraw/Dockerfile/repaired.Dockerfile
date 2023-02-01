FROM python:3.8-alpine

RUN pip install --no-cache-dir requests python-dateutil wcwidth

RUN apk add --no-cache git
RUN pip install --no-cache-dir git+https://github.com/devottys/darkdraw.git
RUN sh -c "echo >>~/.visidatarc import darkdraw"
RUN git clone https://github.com/devottys/studio

ENV TERM="xterm-256color"
ENTRYPOINT ["vd", "studio/darkdraw-tutorial.ddw"]
