FROM ubuntu:20.04

ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1		    \
    PYTHONDONTWRITEBYTECODE=1                       \
    HOME=/home/site/wwwroot

WORKDIR $HOME

RUN apt-get update -y \
&& apt-get install --no-install-recommends -y wget python3 python3-pip \
&& cp /usr/bin/python3 /usr/bin/python \
&& wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
&& dpkg -i packages-microsoft-prod.deb \
&& apt-get update -y \
&& apt-get install --no-install-recommends -y azure-functions-core-tools-3 && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . ./api

WORKDIR $HOME/api

CMD ["func", "host", "start", "--cors", "*"]
