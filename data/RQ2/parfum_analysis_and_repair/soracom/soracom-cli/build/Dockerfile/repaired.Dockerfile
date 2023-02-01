FROM public.ecr.aws/bitnami/golang:1.17.8

RUN apt update && apt upgrade -y && apt install --no-install-recommends -y fakeroot shellcheck zip && rm -rf /var/lib/apt/lists/*;

ADD build.sh /build/

CMD [ "bash", "-x", "/build/build.sh" ]
