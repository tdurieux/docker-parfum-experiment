FROM gableroux/unity3d:2019.1.14f1

RUN apt update && apt upgrade -y && apt install --no-install-recommends -y git curl unzip && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p ~/.ssh
RUN ssh-keyscan -H github.com >> ~/.ssh/known_hosts
RUN curl -f -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt update && apt install --no-install-recommends -y git-lfs=2.8.0 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y curl software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
