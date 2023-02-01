FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nasm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ssh && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tar && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y grub2 && rm -rf /var/lib/apt/lists/*;
