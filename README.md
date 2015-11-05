# AzureDataFactory
This article contains a basic configuration for Azure Data Factory on premise file system to Azure SQL Data Warehouse data movement. 
The following overview assumes you are familiar with data factory concepts like pipelines, activities, datasets and the copy activity. To familiarize yourself with Data Factory basics, review the [Getting Started](https://azure.microsoft.com/en-us/documentation/articles/data-factory-introduction/) article.

## Data Gateway
A Data Management Gateway process must run on the on premise machine to enable a hybrid pipeline. At the time of writing this article, the gateway machine can only be a Windows OS.
The gateway MSI can be downloaded directly from the [Download Center](https://www.microsoft.com/en-us/download/details.aspx?id=39717). Follow [this tutorial](https://azure.microsoft.com/en-us/documentation/articles/data-factory-move-data-between-onprem-and-cloud/#using-the-data-gateway-step-by-step-walkthrough) for a step by step walkthrough of seting up the gateway.

For this tutrial, we will create a gateway named "LocalFilesGateway" that will run on our local Windows machine.


## Resources and References

https://azure.microsoft.com/en-us/documentation/articles/data-factory-onprem-file-system-connector/
https://azure.microsoft.com/en-us/documentation/articles/data-factory-move-data-between-onprem-and-cloud/
https://azure.microsoft.com/en-us/documentation/articles/data-factory-azure-sql-data-warehouse-connector/
https://msdn.microsoft.com/en-us/library/azure/dn894007.aspx
