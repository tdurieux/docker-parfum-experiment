FROM mono:5.8.0.108

RUN apt-get update && apt-get --yes --no-install-recommends install curl unzip wget && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://api.github.com/repos/skbkontur/cement/releases/latest | grep "browser_download_url.*zip" | cut -d : -f 2,3 | tr -d \" | wget -O cement.zip -i -
RUN mkdir ./cement
RUN unzip -o cement.zip -d ./cement
RUN mono ../cement/dotnet/cm.exe init
