$modulePath = Split-Path $PSScriptRoot
$moduleName = Split-Path $modulePath -Leaf
Import-Module "$(Join-Path $modulePath $moduleName).psd1" -Force

<# .Notes
This only works for hashtables with simple keys and values
#>
function Test-HashMatch
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable] $Expected,
        [Parameter(Mandatory, ValueFromPipeline)]
        [hashtable] $Actual
    )
    process
    {
        Set-StrictMode -Version Latest
        $Actual.Keys.Count | Should Be $Expected.Keys.Count

        $expectedObject = [pscustomobject] $Expected
        $actualObject = [pscustomobject] $Actual
        $res = Compare-Object $expectedObject.PsObject.Properties $actualObject.PsObject.Properties
        $res | Should BeNullOrEmpty
    }
}

Describe 'ConvertTo-Hashtable' {
    Set-StrictMode -Version Latest

    $testCases = @(
        @{
            InputArray = @(
                New-Object psobject -Property @{ Name = 'foo' }
                New-Object psobject -Property @{ Name = 'bar' }
            )
            ExpectedResult = @{
                foo = New-Object psobject -Property @{ Name = 'foo' }
                bar = New-Object psobject -Property @{ Name = 'bar' }
            }
            Property = 'Name'
        }

        @{
            InputArray = @(
                New-Object psobject -Property @{ Name = 'foo'; Foo = 'bar' }
                New-Object psobject -Property @{ Name = 'bar'; Spam = 'eggs' }
            )
            ExpectedResult = @{
                foo = New-Object psobject -Property @{ Name = 'foo'; Foo = 'bar' }
                bar = New-Object psobject -Property @{ Name = 'bar'; Spam = 'eggs' }
            }
            Property = 'Name'
        }

        @{
            InputArray = @(
                New-Object psobject -Property @{ Name = 'foo' }
                New-Object psobject -Property @{ Name = 'bar' }
            )
            ExpectedResult = @{
                XFOOX = New-Object psobject -Property @{ Name = 'foo' }
                XBARX = New-Object psobject -Property @{ Name = 'bar' }
            }
            Property = { "x$($_.Name)x".ToUpper() }
        }
    )

    It "Converts to hashtable" -TestCases $testCases {
        param($InputArray, $ExpectedResult, $Property)

        $actual = $InputArray | ConvertTo-Hashtable -Property $Property
        $actual | Test-HashMatch $ExpectedResult
    }

    $testCases = @(
        @{
            InputArray = @(
                New-Object psobject -Property @{ Name = 'foo' }
                New-Object psobject -Property @{ Name = 'foo' }
            )
            Property = 'Name'
        }
    )

    It "Throws on duplicate keys" -TestCases $testCases {
        param($InputArray, $Property)

        { $InputArray | ConvertTo-Hashtable -Property $Property } | Should Throw
    }
}