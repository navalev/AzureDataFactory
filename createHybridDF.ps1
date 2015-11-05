
$df=Get-AzureRmDataFactory -ResourceGroupName DataFactoryGroup -Name HyrbidDF 

New-AzureRmDataFactoryLinkedService $df -File .\AzureSqlDWLinkedService.json
New-AzureRmDataFactoryLinkedService $df -File .\OnPremisesFileServerLinkedService.json
New-AzureRmDataFactoryDataset $df -File .\OnPremisesFile.json
New-AzureRmDataFactoryDataset $df -File .\AzureSqlDWOutput.json
New-AzureRmDataFactoryPipeline $df -File .\CopyLocalFiles2DWPipeline.json

