$modulePath = Split-Path $PSScriptRoot
$moduleName = Split-Path $modulePath -Leaf
Import-Module "$(Join-Path $modulePath $moduleName).psd1" -Force

Describe 'Get-ValueOrDefault' {
    Set-StrictMode -Version Latest

    It 'Handles non-null objects with no default' {
        $now = Get-Date
        Get-ValueOrDefault -InputObject $now -Default $now.AddDays(1) | Should Be $now
    }

    It 'Handles null objects with no default' {
        Get-ValueOrDefault -InputObject $null | Should Be $null
    }

    It 'Handles null objects with default' {
        Get-ValueOrDefault -InputObject $null -Default 'bacon' | Should Be 'bacon'
    }

    It 'Handles null objects with default via pipeline' {
        $inputObject = $null
        $inputObject | Get-ValueOrDefault -Default 'bacon' | Should Be 'bacon'
    }

    It 'Handles null objects with default and positional parameters' {
        $inputObject = $null
        Get-ValueOrDefault $inputObject 'bacon' | Should Be 'bacon'
    }
}