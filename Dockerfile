# Use the .NET 10.0 SDK for building
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy everything
COPY . .

# Find the project file and restore/publish
# Using 'find' is safer because the .csproj might be in a subfolder
RUN dotnet restore $(find . -name "*.csproj" | head -n 1)
RUN dotnet publish $(find . -name "*.csproj" | head -n 1) -c Release -o /app/publish

# Use the .NET 10.0 runtime for the final server
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app

# Copy the published files from the build stage to the current folder
COPY --from=build /app/publish .

# Start the application
# This finds the main .dll file automatically
ENTRYPOINT ["sh", "-c", "dotnet $(ls *.dll | head -n 1)"]
