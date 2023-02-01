# Dockaer Image for udns

FROM crux/python
MAINTAINER James Mills, prologic at shortcircuit dot net dot au

# Services
EXPOSE 53/udp

# Startup
CMD ["udnsd"]

# Application