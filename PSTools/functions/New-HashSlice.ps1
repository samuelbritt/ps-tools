function New-HashSlice
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [hashtable] $InputHash,
        [Parameter()]
        [string[]] $Key
    )
    process
    {
        Set-StrictMode -Version Latest
        $outputHash = @{}
        $Key |
            Where-Object { $Key -ne $null -and $InputHash.ContainsKey($_) } |
            ForEach-Object {
                $outputHash[$_] = $InputHash[$_]
            }

        $outputHash
    }
}