# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /source

# Copy everything from your repo
COPY . .

# Find the project file automatically and publish it
# We use --use-current-runtime to force it to match the environment
RUN dotnet publish $(find . -name "ViennaDotNet.BuildplateRenderer.csproj") \
    -c Release \
    -o /app/out \
    --self-contained false

# Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app

# Copy the output directly into the /app folder
COPY --from=build /app/out ./

# Final check: List files in logs to see if the json is actually there
RUN ls -la /app

ENTRYPOINT ["dotnet", "ViennaDotNet.BuildplateRenderer.dll"]
