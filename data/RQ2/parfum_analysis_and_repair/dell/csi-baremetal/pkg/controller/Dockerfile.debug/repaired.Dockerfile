FROM    controller:base

LABEL   description="Bare-metal CSI Controller Service"

ADD     controller /controller
ADD     dlv /dlv

EXPOSE  40000

ENTRYPOINT ["/dlv", "--listen", "0.0.0.0:40000", "--headless=true", "--api-version=2", "exec", "--", "./controller"]