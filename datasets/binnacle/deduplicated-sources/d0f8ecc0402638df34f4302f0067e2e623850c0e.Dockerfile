FROM iron/base
EXPOSE 6767
EXPOSE 8181

ADD accountservice-linux-amd64 /
ADD healthchecker-linux-amd64 /

HEALTHCHECK --interval=3s --timeout=3s CMD ["./healthchecker-linux-amd64", "-port=6767"] || exit 1
ENTRYPOINT ["./accountservice-linux-amd64", "-configServerUrl=http://configserver:8888", "-profile=test", "-configBranch=P12"]
