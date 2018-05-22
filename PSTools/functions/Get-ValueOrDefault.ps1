function Get-ValueOrDefault
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [psobject] $InputObject,
        [Parameter(Mandatory)]
        [string] $Name,
        [Parameter()]
        [object] $Default = $null
    )
    process
    {
        Set-StrictMode -Version Latest

        if ($InputObject -eq $null)
        {
            return
        }

        $value = $null
        if ($InputObject | Get-Member -Name $Name -MemberType NoteProperty)
        {
            $value = $InputObject.$Name
        }

        if ($value -ne $null)
        {
            Write-Output $value
        }
        else
        {
            Write-Output $Default
        }
    }
}