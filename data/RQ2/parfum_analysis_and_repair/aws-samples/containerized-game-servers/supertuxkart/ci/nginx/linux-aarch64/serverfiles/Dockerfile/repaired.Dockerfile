FROM arm64v8/nginx

RUN apt-get update -y && apt install --no-install-recommends -y telnet && rm -rf /var/lib/apt/lists/*;

CMD [nginx, '-g', 'daemon off;']
