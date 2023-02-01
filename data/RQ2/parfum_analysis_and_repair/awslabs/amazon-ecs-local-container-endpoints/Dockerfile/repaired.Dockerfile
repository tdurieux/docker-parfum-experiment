# Use amazonlinux as the base image so that:
# - we have certificates to make calls to the AWS APIs (/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem)
# - it provides 'sh' excutable that is required by aws-sdk-go credential_process
# NOTE: the amazonlinux:2 base image is multi-arch, so docker should be
# able to detect the correct one to use when the image is run