ARG platform_arg

FROM ghcr.io/virtocommerce/platform:${platform_arg}

WORKDIR /opt/virtocommerce/platform

RUN apt-get update && apt-get install --no-install-recommends -y openssh-server dos2unix && rm -rf /var/lib/apt/lists/*;
COPY wait-for-it.sh /wait-for-it.sh
RUN dos2unix /wait-for-it.sh && chmod +x /wait-for-it.sh

ENTRYPOINT ["dotnet", "VirtoCommerce.Platform.Web.dll"]
