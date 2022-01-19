export PATH=$PATH:/root/.dotnet/tools && \
dotnet --version  && \
dotnet tool install --global dotnet-sonarscanner --version 5.4.1  && \
dotnet sonarscanner begin /k:dotnet /n:dotnet /v:${Version} && \
dotnet build && \
dotnet sonarscanner end