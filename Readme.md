# App Service with mounted Storage File Share

This is a sample project to test the Mounting of an Azure Storage File Share within an Azure Web App.
https://docs.microsoft.com/en-us/azure/app-service/configure-connect-to-azure-storage

The project contains a single api that writes a json file to a configured file path.  When running locally it will write to the project folder, when deployed it writes to the value in the MountPath App Setting.


