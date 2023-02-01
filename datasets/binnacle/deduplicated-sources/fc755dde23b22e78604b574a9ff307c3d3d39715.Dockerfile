FROM centos:7

ARG PSVERSIONSTUB
ARG PSVERSIONSTUBRPM
ARG PACKAGELOCATIONSTUB
ARG TESTLISTSTUB

# Install dependencies
RUN yum install -y \
        curl \
        glibc-locale-source \
        git

# Setup the locale
ENV LANG en_US.UTF-8
ENV LC_ALL $LANG
RUN localedef --charmap=UTF-8 --inputfile=en_US $LANG

RUN curl -L -o powershell-$PSVERSIONSTUBRPM-1.rhel.7.x86_64.rpm $PACKAGELOCATIONSTUB/powershell-$PSVERSIONSTUBRPM-1.rhel.7.x86_64.rpm
RUN yum install -y powershell-$PSVERSIONSTUBRPM-1.rhel.7.x86_64.rpm
RUN git clone --recursive https://github.com/PowerShell/PowerShell.git
RUN pwsh -c "Import-Module /PowerShell/build.psm1;Restore-PSPester -Destination /usr/local/share/powershell/Modules;exit (Invoke-Pester $TESTLISTSTUB -PassThru).FailedCount"
