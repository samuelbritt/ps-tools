function ConvertTo-Hashtable
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject] $InputObject,
        [Parameter(Mandatory)]
        [object] $Property
    )
    begin
    {
        $hash = @{}

        function Get-Key
        {
            [CmdletBinding()]
            param(
                [Parameter(Mandatory, ValueFromPipeline)]
                [psobject] $InputObject,
                [Parameter(Mandatory)]
                [object] $Property
            )
            process
            {
                Set-StrictMode -Version Latest
                $key = $null
                if ($Property -is [scriptblock])
                {
                    $key = $InputObject | ForEach-Object -Process $Property
                }
                elseif ($Property -is [string])
                {
                    $key = $InputObject | Get-MemberOrDefault $Property
                }

                $key
            }
        }
    }
    process
    {
        Set-StrictMode -Version Latest

        $key = $InputObject | Get-Key -Property $Property
        if ($key -eq $null)
        {
            throw ($Errors.INVALID_PROPERTY -f $Property)
        }

        if ($hash.ContainsKey($key))
        {
            throw ($Errors.DUPLICATE_KEY -f $key)
        }

        $hash[$key] = $InputObject
    }
    end
    {
        $hash
    }
}