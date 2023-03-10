FROM nginx

# nginx auth docs: http://nginx.org/en/docs/http/ngx_http_auth_basic_module.html

RUN apt -y update; apt -y --no-install-recommends install apache2-utils && rm -rf /var/lib/apt/lists/*;

# dynamically create password
RUN UUUU=admin && \
    PPPP=$(date +%s | sha256sum | base64 | head -c 43) && \
    htpasswd -bc /etc/nginx/.htpasswd $UUUU $PPPP && \
    echo $PPPP > PPPP.txt # NB: this line persists the password in a file inside the docker image.
                          # Depending on your security threat model, this may be insecure. You can remove that line.

RUN printf "\n\t file PPPP.txt:: \n" && \
    cat PPPP.txt && \
    printf "\n"

COPY ./nginx.conf /etc/nginx/nginx.conf
