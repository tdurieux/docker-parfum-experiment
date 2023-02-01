FROM tiangolo/meinheld-gunicorn-flask:python3.8
LABEL maintainer="Orchest B.V. https://www.orchest.io"

# Refresh SSL certificates
RUN apt-get update \
  && apt-get install --no-install-recommends -y ca-certificates netcat \
  && update-ca-certificates --fresh && rm -rf /var/lib/apt/lists/*;


# Install nodejs for frontend client build
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Get all Python requirements in place and install them.
COPY ./requirements.txt /orchest/services/auth-server/
COPY ./lib/python /orchest/lib/python
WORKDIR /orchest/services/auth-server
RUN pip3 install --no-cache-dir -r requirements.txt

# Get the internal JS library
COPY ./client ./client
COPY ./lib/javascript /orchest/lib/javascript
COPY ./lib/design-system /orchest/lib/design-system

# PNPM files
COPY ./pnpm_files/* /orchest/

# Compile front-end code with npx and compile style.
WORKDIR /orchest

RUN npm run setup
RUN pnpm i && \
  pnpm run build --stream --filter "@orchest/client-auth" && \
  # Clean node_modules to reduce image size
  find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +

# Application files.
WORKDIR /orchest/services/auth-server
COPY ./app ./app

WORKDIR /orchest/services/auth-server/app
COPY ./start.sh /

# Required by base image.
ENV GUNICORN_CONF /orchest/services/auth-server/app/gunicorn_conf.py
ENV APP_MODULE "main:app"
ARG ORCHEST_VERSION
ENV ORCHEST_VERSION=${ORCHEST_VERSION}
