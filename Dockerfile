# Use the official .NET SDK 8.0
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy everything first
COPY . .

# Find the project file and restore dependencies
# This 'find' command helps if the project is in a subfolder
RUN dotnet restore $(find . -name "*.csproj" | head -n 1)

# Build and publish
RUN dotnet publish $(find . -name "*.csproj" | head -n 1) -c Release -o out

# Use the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .

# Start the application
# We use a wildcard to find the DLL since we don't know the exact name
ENTRYPOINT ["sh", "-c", "dotnet $(ls *.dll | head -n 1)"]
