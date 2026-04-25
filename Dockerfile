# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .

# Build the specific project found in your logs
RUN dotnet publish "src/ViennaDotNet.BuildplateRenderer/ViennaDotNet.BuildplateRenderer.csproj" \
    -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/publish .

# Use the exact DLL name from the buildplate renderer
ENTRYPOINT ["dotnet", "ViennaDotNet.BuildplateRenderer.dll"]
