FROM turbonomic/kubeturbo
COPY kubeturbo.debug /opt/turbonomic/bin/kubeturbo
ADD dlv /usr/local/bin/dlv
EXPOSE 40000
ENTRYPOINT ["/usr/local/bin/dlv", "--listen=:40000", "--headless=true", "--api-version=2", "exec", "/opt/turbonomic/bin/kubeturbo"]