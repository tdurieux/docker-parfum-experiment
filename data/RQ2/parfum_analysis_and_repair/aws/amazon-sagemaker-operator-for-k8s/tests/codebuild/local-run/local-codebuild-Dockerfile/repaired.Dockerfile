# Start from the integration test image as a base image.
FROM integration-test-container

# Install aws-iam-authenticator, it is used by EKS kubeconfigs.
RUN curl -f -SO https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator && chmod +x aws-iam-authenticator && mv aws-iam-authenticator /bin

# Create the default kubeconfig directory and copy the kubeconfig to it.
RUN mkdir -p /root/.kube/
COPY local-kubeconfig /root/.kube/config
