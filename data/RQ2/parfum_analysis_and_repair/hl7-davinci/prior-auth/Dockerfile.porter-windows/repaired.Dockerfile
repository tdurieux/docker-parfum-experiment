FROM ubuntu:latest
WORKDIR /porter
RUN apt update && apt -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN chmod u+x get-docker.sh
RUN ./get-docker.sh
RUN curl -f -L https://cdn.porter.sh/latest/install-linux.sh | bash
RUN export PATH="$PATH:~/.porter"
ENV PATH="$PATH:~/.porter"
