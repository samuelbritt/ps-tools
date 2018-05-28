function Assert-Path
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [string] $Path
    )
    process
    {
        Set-StrictMode -Version Latest
        if (!(Test-Path $Path))
        {
            throw ($Script:Errors.INVALID_PATH -f $Path)
        }
    }
}