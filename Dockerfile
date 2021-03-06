FROM mcr.microsoft.com/powershell:7.0.0-rc.3-alpine-3.8
RUN pwsh -c "Install-Module Az.Accounts -Scope AllUsers -Acceptlicense -Force"
RUN pwsh -c "Install-Module Az.Profile -Scope AllUsers -Acceptlicense -Force"
RUN pwsh -c "Install-Module Az.Resources -Scope AllUsers -Acceptlicense -Force"
RUN pwsh -c "Install-Module Az.Storage -Scope AllUsers -Acceptlicense -Force"
COPY ./src/ ./tmp/
ENTRYPOINT ["pwsh","-File","/tmp/scripts/Main.ps1"]