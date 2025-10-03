# This script is used to run the Hexo project locally

# Ensure Node.js is installed
$nodePath = "C:\Program Files\nodejs"
if (-Not (Test-Path "$nodePath\node.exe")) {
    Write-Host "Node.js is not installed. Please install Node.js first." -ForegroundColor Red
    exit 1
}

# Ensure npm is available
if (-Not (Test-Path "$nodePath\npm.cmd")) {
    Write-Host "npm is not available. Please ensure Node.js and npm are installed correctly." -ForegroundColor Red
    exit 1
}

# Install dependencies
Write-Host "Installing dependencies..."
& "$nodePath\npm.cmd" install
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install dependencies." -ForegroundColor Red
    exit 1
}

# Clean the Hexo project
Write-Host "Cleaning the Hexo project..."
& "$nodePath\npx.cmd" hexo clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to clean the Hexo project." -ForegroundColor Red
    exit 1
}

# Generate the Hexo project
Write-Host "Generating the Hexo project..."
& "$nodePath\npx.cmd" hexo generate
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to generate the Hexo project." -ForegroundColor Red
    exit 1
}

# Start the Hexo server
Write-Host "Starting the Hexo server..."
& "$nodePath\npx.cmd" hexo server
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to start the Hexo server." -ForegroundColor Red
    exit 1
}

Write-Host "Hexo server is running. Open your browser and navigate to http://localhost:4000" -ForegroundColor Green