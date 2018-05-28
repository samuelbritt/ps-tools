$modulePath = Split-Path $PSScriptRoot
$moduleName = Split-Path $modulePath -Leaf
Import-Module "$(Join-Path $modulePath $moduleName).psd1" -Force

Describe 'Join-Paths' {
    Set-StrictMode -Version Latest

    $testCases = @(
        @{
            Name = 'Single Path'
            Path = 'foo'
            ExpectedResult = 'foo'
        }
        @{
            Name = 'Two Paths'
            Path = 'foo', 'bar'
            ExpectedResult = 'foo\bar'
        }
        @{
            Name = 'Three Paths'
            Path = 'foo', 'bar', 'baz'
            ExpectedResult = 'foo\bar\baz'
        }
        @{
            Name = 'Many Paths'
            Path = 'foo', 'bar\', '\baz', '/spam/..', 'eggs'
            ExpectedResult = 'foo\bar\baz\spam\..\eggs'
        }
    )
    It "Joins <Name>" -TestCases $testCases {
        param($Name, $Path, $ExpectedResult)
        Join-Paths -Path $Path | Should BeExactly $ExpectedResult
    }
}