FROM  pivotalrabbitmq/rabbitmq-stream


ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb

RUN apt-get update && \
   apt-get install --no-install-recommends -y apt-transport-https && \
   apt-get update && \
   apt-get install --no-install-recommends -y git && \
   apt-get install --no-install-recommends -y dotnet-sdk-6.0 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends make -y && rm -rf /var/lib/apt/lists/*;
