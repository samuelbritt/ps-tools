function Get-MemberOrDefault
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [psobject] $InputObject,
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,
        [Parameter()]
        [object] $Default = $null
    )
    process
    {
        Set-StrictMode -Version Latest

        $memberValue = $InputObject

        if ($InputObject -ne $null)
        {
            $memberValue = $null
            if ($InputObject | Get-Member -Name $Name -MemberType NoteProperty)
            {
                $memberValue = $InputObject.$Name
            }
        }

        $memberValue | Get-ValueOrDefault $Default
    }
}