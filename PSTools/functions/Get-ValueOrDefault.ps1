function Get-ValueOrDefault
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [object] $InputObject,
        [Parameter(Position = 0)]
        [object] $Default = $null
    )
    process
    {
        Set-StrictMode -Version Latest

        if ($InputObject -ne $null)
        {
            Write-Output $InputObject
        }
        else
        {
            Write-Output $Default
        }
    }
}