FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build

# source folder
ENV folder src


WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY ${folder}/*.csproj ./${folder}/
COPY ${folder}/*.config ./${folder}/
RUN nuget restore

# copy everything else and build app
COPY ${folder}/. ./${folder}/
WORKDIR /app/${folder}
RUN msbuild /p:Configuration=Release

# discard build environment and copy artifacts to runtime environment
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/${folder}/. ./

# [optional] - https
RUN powershell.exe -Command " \
   Import-Module IISAdministration; \
   $cert = New-SelfSignedCertificate -DnsName demo.cloudreach.internal -CertStoreLocation cert:\LocalMachine\My; \
   $certHash = $cert.GetCertHash(); \
   $sm = Get-IISServerManager; \
   $sm.Sites[\"Default Web Site\"].Bindings.Add(\"*:443:\", $certHash, \"My\", \"0\"); \
   $sm.CommitChanges();"
EXPOSE 443