FROM ubuntu:16.10

RUN apt-get update -y && apt-get full-upgrade -y
RUN apt-get install --no-install-recommends -y bash-completion zsh curl cowsay git vim bsdmainutils && rm -rf /var/lib/apt/lists/*;

ADD {{scriptName}} /usr/bin/{{scriptName}}
ADD _{{scriptName}} /usr/local/share/zsh/site-functions/_{{scriptName}}
ADD {{scriptName}}.bash-completion /etc/bash-completion.d/{{scriptName}}
RUN chmod 755 /usr/bin/{{scriptName}}

#
# Install oh-my-zsh
#
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true

#
# Enable bash completion
#
RUN echo '\n\
. /etc/bash_completion\n\
source /etc/bash-completion.d/{{scriptName}}\n\
' >> ~/.bashrc

#
# Setup prompt
#
RUN echo 'export PS1="[{{appName}}] \$ "' >> ~/.bashrc
RUN echo 'export PROMPT="[{{appName}}] \$ "' >> ~/.zshrc

#
# Setup a welcome message with basic instruction
#
RUN echo 'cat << EOF\n\
\n\
This Docker provides preconfigured environment for running the command\n\
line REST client for $(tput setaf 6){{appName}}$(tput sgr0).\n\
\n\
For convenience, you can export the following environment variables:\n\
\n\
{{#x-codegen-host-env}}$(tput setaf 3){{x-codegen-host-env}}$(tput sgr0) - server URL, e.g. https://example.com:8080\n\{{/x-codegen-host-env}}
{{#hasAuthMethods}}
{{#authMethods}}
{{#isBasic}}
{{#x-codegen-basicauth-env}}$(tput setaf 3){{x-codegen-basicauth-env}}$(tput sgr0) - basic authentication credentials, e.g.: "username:password"\n\{{/x-codegen-basicauth-env}}
{{/isBasic}}
{{#isApiKey}}
{{#x-codegen-apikey-env}}$(tput setaf 3){{x-codegen-apikey-env}}$(tput sgr0) - access token, e.g. "ASDASHJDG63456asdASSD"\n\{{/x-codegen-apikey-env}}
{{/isApiKey}}
{{/authMethods}}
{{/hasAuthMethods}}
\n\
$(tput setaf 7)Basic usage:$(tput sgr0)\n\
\n\
$(tput setaf 3)Print the list of operations available on the service$(tput sgr0)\n\
$ {{scriptName}} -h\n\
\n\
$(tput setaf 3)Print the service description$(tput sgr0)\n\
$ {{scriptName}} --about\n\
\n\
$(tput setaf 3)Print detailed information about specific operation$(tput sgr0)\n\
$ {{scriptName}} <operationId> -h\n\
\n\
By default you are logged into Zsh with full autocompletion for your REST API,\n\
but you can switch to Bash, where basic autocompletion is also supported.\n\
\n\
EOF\n\
' | tee -a ~/.bashrc ~/.zshrc

ENTRYPOINT ["zsh"]
