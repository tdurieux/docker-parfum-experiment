ADD https://raw.githubusercontent.com/mikefarah/yq/master/LICENSE /opt/bitnami/common/licenses/LICENSE
COPY --from=yq /usr/bin/yq /opt/bitnami/common/bin/