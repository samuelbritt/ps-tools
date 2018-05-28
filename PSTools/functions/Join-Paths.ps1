function Join-Paths
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $Path
    )
    process
    {
        Set-StrictMode -Version Latest
        if ($Path.Count -eq 1)
        {
            return $Path
        }
        else
        {
            return Join-Path $Path[0] (Join-Paths $Path[1..($Path.Count - 1)])
        }
    }
}