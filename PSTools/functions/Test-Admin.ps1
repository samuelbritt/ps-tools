function Test-Admin
{
    [CmdletBinding()]
    param()
    process
    {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = [Security.Principal.WindowsPrincipal] $identity
        Write-Output $principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    }
}