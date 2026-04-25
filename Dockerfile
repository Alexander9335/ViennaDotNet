# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /source
COPY . .

# Publish the ApiServer specifically
RUN dotnet publish "src/ViennaDotNet.ApiServer/ViennaDotNet.ApiServer.csproj" \
    -c Release \
    -o /app/out \
    --self-contained false

# Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/out ./

# Tell .NET to listen on the port Render provides
ENV ASPNETCORE_URLS=http://+:10000

# Expose the common port
EXPOSE 10000

ENTRYPOINT ["dotnet", "ViennaDotNet.ApiServer.dll"]
