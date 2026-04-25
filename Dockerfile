# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .

# Using the exact path from your logs
RUN dotnet publish "src/ViennaDotNet.BuildplateRenderer/ViennaDotNet.BuildplateRenderer.csproj" \
    -c Release \
    -o /app/publish \
    --self-contained false

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app

# Copy EVERYTHING (this includes the missing .runtimeconfig.json)
COPY --from=build /app/publish .

# Force the environment to see the libraries
ENV LD_LIBRARY_PATH=/usr/share/dotnet/shared/Microsoft.NETCore.App/10.0.0
ENV DOTNET_ROOT=/usr/share/dotnet

ENTRYPOINT ["dotnet", "ViennaDotNet.BuildplateRenderer.dll"]
