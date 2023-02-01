FROM us.gcr.io/daisy-284300/veba/ce-ps-base:1.4

ARG POWERCLI_VERSION="12.4.0.18633274"

RUN pwsh -c "\$ProgressPreference = \"SilentlyContinue\"; Install-Module VMware.PowerCLI -RequiredVersion ${POWERCLI_VERSION}" && \
    pwsh -c 'Set-PowerCLIConfiguration -ParticipateInCEIP $true -confirm:$false'

CMD ["pwsh","./server.ps1"]