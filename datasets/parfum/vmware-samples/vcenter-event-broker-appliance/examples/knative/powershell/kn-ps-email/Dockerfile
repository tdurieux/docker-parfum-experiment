FROM us.gcr.io/daisy-284300/veba/ce-ps-base:1.4

ARG MAILKIT_VERSION="3.1.0"

RUN pwsh -c "Install-Module -Name Send-MailKitMessage -RequiredVersion ${MAILKIT_VERSION}"

COPY handler.ps1 handler.ps1

CMD ["pwsh","./server.ps1"]
