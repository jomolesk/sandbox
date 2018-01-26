## This Deletes all protected item Containers and Recovery Points for an array of Recovery Services Vaults.
## If you do not want to delete all protected items in the vaults then the script will need to be adjust to filter only the specified items

Import-Module AzureRm
Add-AzureRmAccount -EnvironmentName AzureUSGovernment


Select-AzureRmSubscription -SubscriptionId bfed0c87-ce95-4ac6-97f1-2ffecc584a05

$rgName = Read-Host "Resource group"

$rcvNames = @("AZ-RCV-01")

for($i=0;$i -lt $rcvNames.Length;$i++){
    $vaults = Get-AzureRmRecoveryServicesVault -ResourceGroupName $rgName | ?{$_.Name -eq $rcvNames[$i]}
    for($j=0;$j -lt $vaults.Length;$j++){
      Set-AzureRmRecoveryServicesVaultContext -Vault $vaults[$j]

      $containers = Get-AzureRmRecoveryServicesBackupContainer -ContainerType AzureVM -BackupManagementType AzureVM
      $containers | %{
          $item = Get-AzureRmRecoveryServicesBackupItem -Container $_ -WorkloadType AzureVM
          Disable-AzureRmRecoveryServicesBackupProtection -Item $item -RemoveRecoveryPoints -Force -Verbose
      }
    }
}
