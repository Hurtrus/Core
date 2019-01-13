# Reading and Manipulating Text Files with PowerShell Core

Get-Content
Add-Content
Set-Content
#region Linux Session
$session = New-PSSession -HostName 'tuxsnips' -UserName root

invoke-command -Session $session -ScriptBlock {
    $PSVersionTable
    write-host " "
    write-host "----- Start content of our authorized_keys -----"
    Get-Content '/home/scott/.ssh/authorized_keys' 
    write-host "----- End content of our authorized_keys -----"
}


$CleanKeyBegin = '---- BEGIN SSH2 PUBLIC KEY ----'
$CleanKeyEnd = '---- END SSH2 PUBLIC KEY ----'
$AddMyKey = Get-Content 'C:\Users\Scott\.ssh\demo_key' | Select-String -NotMatch $CleanKeyBegin | Select-String  -notmatch $CleanKeyEnd

invoke-command -Session $session -ScriptBlock {
    Add-Content -LiteralPath '/home/scott/.ssh/authorized_keys' -Value $Using:AddMyKey

    write-host "----- Start content of our authorized_keys -----"
    Get-Content '/home/scott/.ssh/authorized_keys' 
    write-host "----- End content of our authorized_keys -----"}

#endregion Linux Session

#region Local File Manipulation
$SSHdConfigFile = 'C:\ProgramData\ssh\sshd_config'

(Get-Content $SSHdConfigFile).replace('#PasswordAuthentication yes', 'PasswordAuthentication yes') | Set-Content $SSHdConfigFile


# Adds $AddSSHConfigSubSystem

# Removes $AddSSHConfigSubSystem
(Get-Content $SSHdConfigFile).Replace('# override default of no subsystems', '') | Set-Content $SSHdConfigFile

#endregion Local File Manipulation

#region Reading content as it is written

Get-Content  c:\temp\Processes.txt –Wait | 
    ForEach-Object {$_ ; if ($_ -Match "pwsh") {break} }

#endregion Reading content as it is written