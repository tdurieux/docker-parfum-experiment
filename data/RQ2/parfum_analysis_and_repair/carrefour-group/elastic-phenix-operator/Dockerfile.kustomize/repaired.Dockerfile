FROM zillownyc/kustomize:3.5.4 as kustomize

FROM centos:7
COPY --from=kustomize /usr/local/bin/kustomize /usr/local/bin/kustomize
ENV PATH=$PATH:/usr/local/bin/kustomize/bin