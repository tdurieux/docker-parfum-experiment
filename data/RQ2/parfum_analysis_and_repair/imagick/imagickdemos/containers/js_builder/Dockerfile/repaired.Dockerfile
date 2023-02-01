FROM node:14.4.0-stretch-slim


RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git && rm -rf /var/lib/apt/lists/*;



WORKDIR /var/app

#   CMD sh /var/app/containers/js_builder/entrypoint.sh
CMD tail -f /var/app/containers/js_builder/README_npm.md