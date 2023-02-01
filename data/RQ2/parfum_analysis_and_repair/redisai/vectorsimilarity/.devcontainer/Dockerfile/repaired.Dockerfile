FROM redisfab/clang:13-x64-bullseye
RUN apt-get update -qq && apt-get install --no-install-recommends -y zsh && rm -rf /var/lib/apt/lists/*;
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" y
