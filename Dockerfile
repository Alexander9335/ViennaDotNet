# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy all files
COPY . .

# Find the project and publish it specifically
# We use -r linux-x64 to ensure it builds for Render's servers
RUN dotnet publish $(find . -name "*.csproj" | head -n 1) -c Release -o /app/publish -r linux-x64 --self-contained false

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app

# Copy EVERYTHING from the publish folder
COPY --from=build /app/publish .

# Instead of searching, we tell it EXACTLY what to run
ENTRYPOINT ["dotnet", "ViennaDotNet.dll"]
