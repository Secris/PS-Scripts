Param(
    [Parameter(Mandatory=$true)]
    [string]$ComputerName
)

if($null -eq $AdminCreds) {
    $AdminCreds = Get-Credential
}

# TODO - Find source for this snippet.
Try {
    (nltest /dsgetdc:[DOMAIN] /DS_6 /avoidself | findstr 'DC: ').split(" ") | %{

        If($_ -like '\\*'){
            #DC Found
                $DC= $_.replace('\\','')
        }
    }
}
Catch {
    $DC = $false #No DC found
}


If ($DC -and (Test-Connection $DC -Quiet -Count 1)){
    #$DC exists
    $CompObject = Invoke-Command -ComputerName $DC -ScriptBlock {
        Get-ADComputer $using:ComputerName -Property ms-Mcs-AdmPwd
    } -Credential $AdminCreds
    Write-Output "Local Admin for $ComputerName :"
    Write-Host -ForegroundColor yellow "`t", $CompObject.'ms-Mcs-AdmPwd'
}
Else{
    #$DC is $false
        write-host "Nearest Domain controller not found!"
}

