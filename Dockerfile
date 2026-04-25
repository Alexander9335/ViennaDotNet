# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /source
COPY . .

# Force the creation of runtimeconfig.json and copy everything to /app/out
RUN dotnet publish "src/ViennaDotNet.BuildplateRenderer/ViennaDotNet.BuildplateRenderer.csproj" \
    -c Release \
    -o /app/out \
    --self-contained false \
    -p:CopyLocalLockFileAssemblies=true \
    -p:GenerateRuntimeConfigurationFiles=true

# Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app

# Copy the output directly
COPY --from=build /app/out ./

# Check the file list again - we MUST see the .runtimeconfig.json file here
RUN ls -la /app

ENTRYPOINT ["dotnet", "ViennaDotNet.BuildplateRenderer.dll"]
