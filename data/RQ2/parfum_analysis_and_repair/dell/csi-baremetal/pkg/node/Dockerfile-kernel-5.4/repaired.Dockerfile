FROM    node:base-kernel-5.4

LABEL   description="Bare-metal CSI Node Service"

ADD     node  node

EXPOSE  9999

ENTRYPOINT ["/node"]