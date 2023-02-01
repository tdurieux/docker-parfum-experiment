FROM node:14.4.0-stretch-slim

WORKDIR /var/app/app

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git && rm -rf /var/lib/apt/lists/*;

# CMD sh /var/app/containers/css_builder/build_prod_assets.sh
CMD sh /var/app/containers/css_builder/entrypoint.sh

