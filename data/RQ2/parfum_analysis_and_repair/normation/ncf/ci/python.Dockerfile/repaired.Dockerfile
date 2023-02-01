FROM debian:11

ARG USER_ID=1000
COPY ci/user.sh .
RUN ./user.sh $USER_ID

RUN apt-get update && apt-get install --no-install-recommends -y git wget gnupg2 make python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir avocado-framework pylint Jinja2

# Accept all OSes
ENV UNSUPPORTED=y
RUN wget https://repository.rudder.io/tools/rudder-setup && sh ./rudder-setup setup-agent latest || true
