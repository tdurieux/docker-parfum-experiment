FROM node:14 as build
# Yarn workspaces are broken
RUN apt-get update && apt-get install --no-install-recommends udev libusb-1.0-0-dev cmake build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://phabricator.boreal.systems/source/Director.git /borealsystems/director --recursive
WORKDIR /borealsystems/director
RUN yarn workspace ui install
RUN yarn workspace ui run build && yarn cache clean;

FROM nginx:1.15
ADD ./nginx.conf /etc/nginx/conf.d/default.conf
WORKDIR /borealsystems/director/ui
ADD ./src/public/* ./public/
COPY --from=build /borealsystems/director/packages/ui/dist/* ./public/dist/
