# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .

# We publish with --no-self-contained to keep it simple
RUN dotnet publish "src/ViennaDotNet.BuildplateRenderer/ViennaDotNet.BuildplateRenderer.csproj" \
    -c Release \
    -o /app/publish \
    --self-contained false

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app

# Copy all published files
COPY --from=build /app/publish .

# The CRITICAL FIX: Tell .NET exactly where the app is and how to run it
ENV ASPNETCORE_URLS=http://+:10000
ENTRYPOINT ["dotnet", "ViennaDotNet.BuildplateRenderer.dll"]
