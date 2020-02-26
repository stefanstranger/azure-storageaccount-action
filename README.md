# actions
Github Actions repository


# Build Docker images
docker build --rm -f "dockerfile" -t storageaccount:latest storageaccount

# Call Docker container with input arguments
docker run -it storageaccount "-action" "createStorageAccount" "-StorageAccountName" "githubactiondemosa" "-ResourceGroupName" "ghactiondemo-rg" "-Location" "westeurope" "-AccountType" "Standard_LRS" "-AccessTier" "Cool" "-ServiceConnection" "SERVICECONNECTION"

docker run -it storageaccount "-Credential" ''"'{"FirstName":"Stefan","LastName":"Stranger"}'"''

# Remove Storage Account
docker run -it storageaccount "-action" "removeStorageAccount" "-StorageAccountName" "githubactiondemosa" "-ResourceGroupName" "ghactiondemo-rg"

# Example worklow
steps:
  - name: Hello world
    run: echo $credentials 
    env:
      credentials: ${{ secrets.AZURE_CREDENTIALS }}