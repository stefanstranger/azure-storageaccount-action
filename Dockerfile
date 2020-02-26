FROM mcr.microsoft.com/powershell:7.0.0-rc.3-alpine-3.8
RUN pwsh -c "Install-Module Az.Accounts -Acceptlicense -Force"
RUN pwsh -c "Install-Module Az.Profile -Acceptlicense -Force"
RUN pwsh -c "Install-Module Az.Resources -Acceptlicense -Force"
RUN pwsh -c "Install-Module Az.Storage -Acceptlicense -Force"
COPY ./src/ ./tmp/
RUN pwsh -c "Get-ChildItem ./ -Recurse"
ENTRYPOINT ["pwsh","-File","./tmp/scripts/Main.ps1"]