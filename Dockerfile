FROM mcr.microsoft.com/powershell:7.0.0-rc.3-alpine-3.8
RUN pwsh -c "Install-Module Az.Accounts -Scope Global -Acceptlicense -Force"
RUN pwsh -c "Install-Module Az.Profile -Scope Global -Acceptlicense -Force"
RUN pwsh -c "Install-Module Az.Resources -Scope Global -Acceptlicense -Force"
RUN pwsh -c "Install-Module Az.Storage -Scope Global -Acceptlicense -Force"
RUN pwsh -c "[Environment]::GetEnvironmentVariable('psmodulepath')"
RUN pwsh -c "Get-Module -List"
COPY ./src/ ./tmp/
ENTRYPOINT ["pwsh","-File","/tmp/scripts/Main.ps1"]