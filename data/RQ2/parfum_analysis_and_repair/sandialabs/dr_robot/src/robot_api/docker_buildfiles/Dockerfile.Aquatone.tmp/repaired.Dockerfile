FROM andrius/alpine-ruby

ENV http_proxy $proxy
ENV https_proxy $proxy

RUN if [ -n $dns ];\
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
    apk update && apk upgrade && apk add --no-cache git build-base ruby ruby-bundler ruby-dev gcc libffi ruby-json libc-dev make linux-headers libffi-dev

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
    if [ -n "$$http_proxy" ]; \
    then gem install --http-proxy=$http_proxy aquatone;\
    else gem install aquatone; \
    fi;

RUN mkdir -p $output

ENTRYPOINT aquatone-discover --thread 40 --ignore-private --domain "$target" && mv /root/aquatone/$target/hosts.txt $output/aquatone.txt