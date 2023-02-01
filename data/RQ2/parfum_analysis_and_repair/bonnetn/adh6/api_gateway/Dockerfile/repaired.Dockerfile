FROM python:3.7-slim-stretch
EXPOSE 443

# Install dependencies
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
  build-essential \
  python3-dev \
  libpcre3 \
  libpcre3-dev \
  libssl-dev \
  && useradd uwsgi && rm -rf /var/lib/apt/lists/*;



RUN pip install --no-cache-dir uwsgi

WORKDIR /adh6/api_gateway

# python-ldap requirements
RUN apt-get install --no-install-recommends -y libsasl2-dev python3-dev libldap2-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

# Install python requirements
COPY api_gateway/requirements.txt ./
RUN pip3 install --no-cache-dir -r ./requirements.txt

# Copy source files
COPY ./api_gateway ./

# Launch the app
CMD ["uwsgi", "--ini", "uwsgi.ini"]
