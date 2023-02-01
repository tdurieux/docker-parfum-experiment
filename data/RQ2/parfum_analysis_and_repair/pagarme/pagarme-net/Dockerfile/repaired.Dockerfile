FROM mono:4.2

RUN apt-get update && apt-get install --no-install-recommends -y nuget gtk-sharp2 nunit-console referenceassemblies-pcl && rm -rf /var/lib/apt/lists/*;

COPY . /code
WORKDIR /code

CMD nuget restore PagarMe.sln \
    && xbuild PagarMe.sln \
    && nunit-console ./PagarMe.Tests/bin/Debug/PagarMe.Tests.dll
