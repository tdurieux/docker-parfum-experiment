FROM ubuntu:18.04

# Install Nginx.
RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y nginx && \
  apt-get install --no-install-recommends -y vim && \
  apt-get install --no-install-recommends -y supervisor && \
  apt-get install --no-install-recommends -y software-properties-common && \
  apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;


RUN \
  add-apt-repository -y ppa:deadsnakes/ppa && \
  apt-get install --no-install-recommends -y python3.7 && rm -rf /var/lib/apt/lists/*;

RUN \
  curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
  python3.7 get-pip.py

WORKDIR /app

COPY ./website/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ./deploy/website/nginx.conf /etc/nginx/nginx.conf
COPY ./deploy/website/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./website website
COPY ./title_maker_pro title_maker_pro
COPY ./word_service word_service
COPY ./deploy/secret_env_vars.sh /app/secret_env_vars.sh

# Expose ports.
EXPOSE 8080

ENTRYPOINT ["/bin/bash", "-c", "source secret_env_vars.sh && supervisord"]
# ENTRYPOINT ["/bin/bash"]
