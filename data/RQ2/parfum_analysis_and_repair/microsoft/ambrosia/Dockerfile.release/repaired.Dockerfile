FROM ambrosia/ambrosia-dev as dev

# The release does not require dotnet SDK to run Ambrosia binaries.
# So we start with a generic Ubuntu image:
FROM ubuntu:18.04

# Also, apache2-utils provides rotatelogs, used by runAmbrosiaService.sh
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y apache2-utils && rm -rf /var/lib/apt/lists/*;

# These dependencies are listed as .NET core runtime native dependencies:
#  https://docs.microsoft.com/en-us/dotnet/core/linux-prerequisites?tabs=netcore2x
RUN apt-get install --no-install-recommends -y liblttng-ust0 libcurl3 libssl1.0.0 libkrb5-3 zlib1g libicu60 && rm -rf /var/lib/apt/lists/*;
# libicu52 (for 14.x)
# libicu55 (for 16.x)
# libicu57 (for 17.x)
# libicu60 (for 18.x)

# These are additional .NET core dependencies BEFORE version 2.1:
RUN apt-get install --no-install-recommends -y libunwind-dev libuuid1 && rm -rf /var/lib/apt/lists/*;

COPY --from=dev /ambrosia/bin /ambrosia/bin

ENV AMBROSIA_BINDIR="/ambrosia/bin"
ENV PATH="${PATH}:/ambrosia/bin"
