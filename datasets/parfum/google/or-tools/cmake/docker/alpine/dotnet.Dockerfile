FROM ortools/cmake:alpine_swig AS env

# .NET install
RUN apk add --no-cache wget icu-libs libintl \
&& mkdir -p /usr/share/dotnet \
&& ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# see: https://dotnet.microsoft.com/download/dotnet-core/3.1
RUN dotnet_sdk_version=3.1.415 \
&& wget -qO dotnet.tar.gz \
"https://dotnetcli.azureedge.net/dotnet/Sdk/${dotnet_sdk_version}/dotnet-sdk-${dotnet_sdk_version}-linux-musl-x64.tar.gz" \
&& dotnet_sha512='20297eb436db2fe0cb3d8edfe4ad5b7c7871116616843314830533471a344f0ca943fbc5f92685113afc331a64c90f271245a36be1c232c364add936dd06d13d' \
&& echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
&& tar -C /usr/share/dotnet -oxzf dotnet.tar.gz \
&& rm dotnet.tar.gz
# Trigger first run experience by running arbitrary cmd
RUN dotnet --info

# see: https://dotnet.microsoft.com/download/dotnet-core/6.0
RUN dotnet_sdk_version=6.0.100 \
&& wget -qO dotnet.tar.gz \
"https://dotnetcli.azureedge.net/dotnet/Sdk/$dotnet_sdk_version/dotnet-sdk-${dotnet_sdk_version}-linux-musl-x64.tar.gz" \
&& dotnet_sha512='428082c31fd588b12fd34aeae965a58bf1c26b0282184ae5267a85cdadc503f667c7c00e8641892c97fbd5ef26a38a605b683b45a0fef2da302ec7f921cf64fe' \
&& echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
&& tar -C /usr/share/dotnet -oxzf dotnet.tar.gz \
&& rm dotnet.tar.gz
# Trigger first run experience by running arbitrary cmd
RUN dotnet --info

# Add the library src to our build env
FROM env AS devel
WORKDIR /home/project
COPY . .

FROM devel AS build
RUN cmake -version
RUN cmake -S. -Bbuild -DBUILD_DOTNET=ON -DBUILD_CXX_SAMPLES=OFF -DBUILD_CXX_EXAMPLES=OFF
RUN cmake --build build --target all -v
RUN cmake --build build --target install -v

FROM build AS test
RUN CTEST_OUTPUT_ON_FAILURE=1 cmake --build build --target test

FROM env AS install_env
WORKDIR /home/sample
COPY --from=build /home/project/build/dotnet/packages/*.nupkg ./

FROM install_env AS install_devel
COPY cmake/samples/dotnet .

FROM install_devel AS install_build
RUN dotnet build

FROM install_build AS install_test
RUN dotnet test
