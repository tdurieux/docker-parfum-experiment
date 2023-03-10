FROM jenkins/jenkins

# Switch to root to install .NET Core SDK
USER root

# Show distro information!
RUN uname -a && cat /etc/*release

# Based on instructiions at https://www.microsoft.com/net/download/linux-package-manager/debian9/sdk-current
# Install dependency for .NET 5
RUN apt-get update
RUN apt-get install --no-install-recommends -y curl libunwind8 gettext apt-transport-https && rm -rf /var/lib/apt/lists/*;

# Based on instructions at https://www.microsoft.com/net/download/linux-package-manager/debian9/sdk-current
# Install microsoft.qpg
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/dotnetdev.list'

# Install the .NET 5framework
RUN apt-get update
RUN apt-get install --no-install-recommends -y dotnet-sdk-5.0 && rm -rf /var/lib/apt/lists/*;

# Install the npm
RUN apt-get install --no-install-recommends -y curl \
  && curl -f -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get install --no-install-recommends -y nodejs \
  && curl -f -L https://www.npmjs.com/install.sh | sh && rm -rf /var/lib/apt/lists/*;

# Install cnpm
RUN npm install cnpm -g && npm cache clean --force;

RUN npm -v
RUN cnpm -v

# Switch back to the jenkins user.
USER jenkins