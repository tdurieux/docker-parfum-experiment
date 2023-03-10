ARG IMAGE_NAME
FROM ${IMAGE_NAME}:latest
LABEL maintainer "Takuya Takeuchi <takuya.takeuchi.dev@gmail.com>"

RUN yum update -y && yum install -y \
    gtk2-devel && rm -rf /var/cache/yum

# Reference
# https://dotnet.microsoft.com/download/linux-package-manager/centos7/sdk-2.1.402

# Register Microsoft key and feed
RUN rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm

# Install the .NET SDK
ENV DOTNET_SDK_VERSION 3.1
RUN yum update -y && yum install -y \
    dotnet-sdk-${DOTNET_SDK_VERSION} \
 && yum clean all && rm -rf /var/cache/yum

# Trigger first run experience by running arbitrary cmd to populate local package cache
RUN dotnet help
