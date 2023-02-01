FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y curl nginx && rm -rf /var/lib/apt/lists/*;

RUN curl -sfL $( curl -f -s https://api.github.com/repos/powerman/dockerize/releases/latest | grep -i /dockerize-$(uname -s)-$(uname -m)\" | cut -d\" -f4) | install /dev/stdin /usr/local/bin/dockerize

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

ADD default.tmpl /etc/nginx/sites-available/default.tmpl

EXPOSE 80

CMD ["dockerize", "-template", "/etc/nginx/sites-available/default.tmpl:/etc/nginx/sites-available/default", "-stdout", "/var/log/nginx/access.log", "-stderr", "/var/log/nginx/error.log", "nginx"]
