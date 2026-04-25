# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .

# Publish as a Single File / Self-Contained app
# This puts the .NET runtime INSIDE your app folder
RUN dotnet publish $(find . -name "*.csproj" | head -n 1) \
    -c Release \
    -o /app/publish \
    --self-contained true \
    -r linux-x64

# Stage 2: Runtime (We use a base OS image since the app has its own .NET now)
FROM mcr.microsoft.com/dotnet/runtime-deps:10.0
WORKDIR /app
COPY --from=build /app/publish .

# We need to find the executable (not the .dll)
ENTRYPOINT ["sh", "-c", "./$(find . -maxdepth 1 -executable -type f | head -n 1)"]
