FROM docker.io/amazon/aws-cli
RUN yum install -y jq bind-utils
COPY update-route53.sh /bin
VOLUME ["/root/.aws"]
ENTRYPOINT ["/bin/update-route53.sh"]
