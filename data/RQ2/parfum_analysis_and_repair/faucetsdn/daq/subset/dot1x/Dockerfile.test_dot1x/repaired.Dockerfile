FROM daqf/aardvark:latest

RUN apt-get update && \
    apt-get install --no-install-recommends -y freeradius git gcc python3-dev musl-dev g++ python3-yaml && rm -rf /var/lib/apt/lists/*;

COPY misc/freeradius/users /etc/freeradius/3.0/users
COPY misc/freeradius/certs /etc/freeradius/3.0/certs
COPY misc/freeradius/default/eap /etc/freeradius/3.0/mods-enabled/eap
COPY misc/freeradius/clients.conf /etc/freeradius/3.0/clients.conf


COPY subset/dot1x/authenticator/ authenticator/
COPY subset/dot1x/test_dot1x test_dot1x

EXPOSE \
    1812/udp \
    1813/udp \
    18120

CMD ["./test_dot1x"]
