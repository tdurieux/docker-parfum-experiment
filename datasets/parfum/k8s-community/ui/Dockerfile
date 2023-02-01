FROM busybox

# Service env parameters
ENV SERVICE_HOST 0.0.0.0
ENV SERVICE_PORT 8080

# Services-Dependencies
ENV USERMAN_BASE_URL https://services.k8s.community/user-manager

# DB parameters
ENV UIDB_USER k8scomm
ENV UIDB_PASSWORD k8scomm
ENV UIDB_NAME k8s_community

# additional env parameters
ENV NAMESPACE=k8s_community
ENV GITHUB_CLIENT_ID f778...
ENV GITHUB_CLIENT_SECRET 807ff71...
ENV GITHUB_OAUTH_STATE just-a-very-secret-state
ENV K8S_GUEST_TOKEN Gfn5Kf0e1Fisg4b9Fmv6FdS8b5dSo6JC

COPY certs /etc/ssl/certs/
COPY static /static
COPY templates /templates
COPY bin/linux-amd64/ui /

EXPOSE $SERVICE_PORT

CMD ["/ui"]
