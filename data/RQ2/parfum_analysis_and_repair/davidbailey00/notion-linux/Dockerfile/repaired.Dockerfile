FROM node:buster
RUN apt-get update
RUN apt-get install --no-install-recommends -y p7zip-full && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y fakeroot && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rpm && rm -rf /var/lib/apt/lists/*;
