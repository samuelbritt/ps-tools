$modulePath = Split-Path $PSScriptRoot
$moduleName = Split-Path $modulePath -Leaf
Import-Module "$(Join-Path $modulePath $moduleName).psd1" -Force

function Test-HashesMatch
{
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [hashtable] $Actual,
        [Parameter(Mandatory)]
        [hashtable] $Expected
    )

    process
    {
        Set-StrictMode -Version Latest
        if ($Expected -eq $null -and $Actual -eq $null)
        {
            return $true
        }

        if (($Expected -eq $null -and $Actual -ne $null) -or
            ($Expected -ne $null -and $Actual -eq $null))
        {
            return $false
        }

        if ($Expected.Keys.Count -ne $Actual.Keys.Count)
        {
            return $false
        }

        $Expected.Keys | ForEach-Object {
            if ($Expected[$_] -ne $Actual[$_])
            {
                return $false
            }
        }

        return $true
    }
}

Describe 'New-HashSlice' {
    Set-StrictMode -Version Latest

    BeforeEach {
        $InputHash = @{
            Foo = "bar"
            Spam = "eggs"
            Now = (Get-Date '2018-05-21 7:25 PM')
        }
    }

    $testCases = @(
        @{
            Name = "Null key"
            Key = $null
            ExpectedResult = @{}
        }
        @{
            Name = "Empty key"
            Key = @()
            ExpectedResult = @{}
        }
        @{
            Name = "Valid key"
            Key ='Foo'
            ExpectedResult = @{
                Foo = "bar"
            }
        }
        @{
            Name = "Valid keys"
            Key ='Foo', 'Now'
            ExpectedResult = @{
                Foo = "bar"
                Now = (Get-Date '2018-05-21 7:25 PM')
            }
        }
        @{
            Name = "Invalid keys"
            Key ='Foo', 'Now', '__not_a_key__'
            ExpectedResult = @{
                Foo = "bar"
                Now = (Get-Date '2018-05-21 7:25 PM')
            }
        }
    )

    It "Slices <Name>" -TestCases $testCases {
        param($Name, $Key, $ExpectedResult)
        $InputHash | New-HashSlice -Key $Key |
            Test-HashesMatch -Expected $ExpectedResult |
            Should Be $true
    }
}