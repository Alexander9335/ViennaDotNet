# Use the .NET 10.0 SDK
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /app

# Copy everything
COPY . .

# Find and restore the project
RUN dotnet restore $(find . -name "*.csproj" | head -n 1)

# Build and publish
RUN dotnet publish $(find . -name "*.csproj" | head -n 1) -c Release -o out

# Use the .NET 10.0 runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/out .

# Start the application
ENTRYPOINT ["sh", "-c", "dotnet $(ls *.dll | head -n 1)"]
