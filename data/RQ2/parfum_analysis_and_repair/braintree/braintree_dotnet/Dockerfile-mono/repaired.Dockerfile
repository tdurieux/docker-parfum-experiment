FROM debian:buster

RUN apt-get update
RUN apt-get -y --no-install-recommends install rake gnupg curl apt-transport-https dirmngr gnupg ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian buster main" | tee /etc/apt/sources.list.d/mono-official.list
RUN apt-get update

RUN apt-get -y --no-install-recommends install mono-devel mono-complete mono-dbg referenceassemblies-pcl ca-certificates-mono mono-xsp4 mono-xbuild mono-vbnc binutils fsharp nuget libnewtonsoft-json-cil-dev libnewtonsoft-json5.0-cil && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install curl libunwind8 gettext apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-buster-prod buster main" | tee /etc/apt/sources.list.d/dotnetdev.list
RUN apt-get update
RUN apt-get -y --no-install-recommends install dotnet-sdk-3.1 && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/admin/bt/braintree-dotnet
