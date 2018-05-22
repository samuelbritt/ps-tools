$modulePath = Split-Path $PSScriptRoot
$moduleName = Split-Path $modulePath -Leaf
Import-Module "$(Join-Path $modulePath $moduleName).psd1" -Force

Describe 'Get-MemberOrDefault' {
    Set-StrictMode -Version Latest

    BeforeEach {
        $InputObject = New-Object psobject -Property @{
            Spam = "eggs"
            Foo = $null
        }
    }

    $testCases = @(
        @{
            Name = "Valid member name"
            MemberName = 'Spam'
            Default = $null
            ExpectedResult = "eggs"
        }
        @{
            Name = "Null-valued member with no default"
            MemberName = 'Foo'
            Default = $null
            ExpectedResult = $null
        }
        @{
            Name = "Null-valued member with default"
            MemberName = 'Foo'
            Default = 'bacon'
            ExpectedResult = 'bacon'
        }
        @{
            Name = "Invalid member name with no default"
            MemberName = '__not_a_member__'
            Default = $null
            ExpectedResult = $null
        }
        @{
            Name = "Invalid member name with default"
            MemberName = '__not_a_member__'
            Default = 'bacon'
            ExpectedResult = 'bacon'
        }
    )

    It "Gets <Name>" -TestCases $testCases {
        param($Name, $MemberName, $Default, $ExpectedResult)
        $params = @{
            Name = $MemberName
        }

        if ($Default)
        {
            $params['Default'] = $Default
        }

        $InputObject | Get-MemberOrDefault @params | Should BeExactly $ExpectedResult
    }

    It 'Handles null input with no default' {
        Get-MemberOrDefault -InputObject $null -Name 'test' | Should Be $null
    }

    It 'Handles null input with default' {
        Get-MemberOrDefault -InputObject $null -Name 'test' -Default 'bacon' | Should Be 'bacon'
    }
}