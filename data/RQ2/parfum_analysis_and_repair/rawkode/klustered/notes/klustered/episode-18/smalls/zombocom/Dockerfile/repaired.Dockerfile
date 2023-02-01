FROM debian as build

RUN apt-get update -y && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget --recursive https://html5zombo.com

FROM nginx
COPY --from=build /html5zombo.com /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf