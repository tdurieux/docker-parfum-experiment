# Our custom docker image with app
FROM fedora:23
MAINTAINER <RH>

LABEL company="Redhat" product="CFME" environment="dev" tier="test"

# mandatory packages