
This article contains a basic configuration for Azure Data Factory on premise file system to Azure SQL Data Warehouse data movement. 
The following overview assumes you are familiar with data factory concepts like pipelines, activities, datasets and the copy activity. To familiarize yourself with Data Factory basics, review the [Getting Started](https://azure.microsoft.com/en-us/documentation/articles/data-factory-introduction/) article.

## Prerequisites
* Windows machine (to host the Data Management Gateway)
* [Azure SQL Data Warehouse](https://azure.microsoft.com/en-us/documentation/articles/sql-data-warehouse-get-started-provision/)
* A table in the SQL Data Warehouse database - destiantion for file copy.

## Setting up a Data Factory Account

Create a Data Factory account within a Resource Group. You can either create a new Resource Group, or use an exsiting one.

In the [Azure Portal](portal.azure.com) click on New --> Data + Analytics --> Data Factory. Set a name, select the subscription, resource group and location and click on Create:

![alt tag] (./images/createDataFactory.JPG)

Alternativly, you can use Powershell to create the resource group and the account:
```
New-AzureRmResourceGroup -Location NorthEurope -Name DataFactoryGroup
New-AzureRmDataFactory -Location NorthEurope -Name HyrbidDF -ResourceGroupName DataFactoryGroup
```

## Data Gateway
A Data Management Gateway process must run on the on premise machine to enable a hybrid pipeline. At the time of writing this article, the gateway machine can only be a Windows OS.
The gateway MSI can be downloaded directly from the [Download Center](https://www.microsoft.com/en-us/download/details.aspx?id=39717). 

For this tutrial, create a gateway named "FilesGateway" that will run on the local Windows machine. Follow [this tutorial](https://azure.microsoft.com/en-us/documentation/articles/data-factory-move-data-between-onprem-and-cloud/#using-the-data-gateway-step-by-step-walkthrough) for a step by step walkthrough of seting up the gateway.

```
New-AzureRmDataFactoryGateway -DataFactoryName HyrbidDF -Name FilesGateway -ResourceGroupName DataFactoryGroup
$Key = New-AzureRmDataFactoryGatewayKey -DataFactoryName hyrbiddf -GatewayName FilesGateway -ResourceGroupName DataFactoryGroup

cd 'C:\Program Files\Microsoft Data Management Gateway\1.0\PowerShellScript'
.\RegisterGateway.ps1 $Key.GatewayKey

Get-AzureRmDataFactoryGateway -DataFactoryName HyrbidDF -ResourceGroupName DataFactoryGroup -Name FilesGateway

```

## Setting Up a Hybrid Data Factory Pipeline
Data Factory pipeline can be created using the Azure Preview Portal, using the "Author and Deploy" dashboard under the create Data Factory Account. We will create the following componants:

1. Linked Service for SQL Data Warehouse - use AzureSqlDWLinkedService.json and replace the connection string 

2. Linked Service for on premise File System - use OnPremisesFile.json and replace the CSV file name and path

3. DataSet for SQL Data Warehouse - use AzureSqlDWOutput.json. Replace the table name with the detination table name in the SQL Data warehouse database

4. DataSet for on premise File System - use OnPremisesFileServerLinkedService.json and replace the user and password to access the file system.

5. Pipeline - copy CVS file content to SQL Warehouse table. Use CopyLocalFiles2DWPipeline.json and set a valid date for the start and end times.

You can use a powershell script to automaticly deploy the pipeline (createHybridDF.ps1):
```
$df=Get-AzureRmDataFactory -ResourceGroupName DataFactoryGroup -Name HyrbidDF 

New-AzureRmDataFactoryLinkedService $df -File .\AzureSqlDWLinkedService.json
New-AzureRmDataFactoryLinkedService $df -File .\OnPremisesFileServerLinkedService.json
New-AzureRmDataFactoryDataset $df -File .\OnPremisesFile.json
New-AzureRmDataFactoryDataset $df -File .\AzureSqlDWOutput.json
New-AzureRmDataFactoryPipeline $df -File .\CopyLocalFiles2DWPipeline.json
```

![alt tag] (./images/diagram.JPG)

Now we have a very simple pipeline that copies the content of a CSV into a matching table in SQL Data Warehouse database.
Note that this pipeline is **unalbe to process any header lines in the source file**. At the time of writing this article, FileSystemSource does not have any properties, and simply copies the files as-is. [Sources and Sinks Properties](https://msdn.microsoft.com/en-us/library/azure/dn894007.aspx)

## Resources and References

https://azure.microsoft.com/en-us/documentation/articles/data-factory-onprem-file-system-connector/
https://azure.microsoft.com/en-us/documentation/articles/data-factory-move-data-between-onprem-and-cloud/
https://azure.microsoft.com/en-us/documentation/articles/data-factory-azure-sql-data-warehouse-connector/
https://msdn.microsoft.com/en-us/library/azure/dn894007.aspx
