FROM stackbrew/debian:wheezy

[[ updateApt ]]
[[ addUserFiles ]]

WORKDIR [[ .Container.GetFirstMountedDir ]]

# Install PHP 5.4
RUN apt-get -y --no-install-recommends -f install php5 php5-mysql php5-mcrypt php5-curl curl && rm -rf /var/lib/apt/lists/*;

# Add custom setup script
[[ beforeAfterScripts ]]

CMD [[ if (.Container.HasAfterScript) ]] /bin/bash /root/after-setup.sh && [[end]] /bin/bash
