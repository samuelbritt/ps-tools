@{
    RootModule = 'PSTools.psm1'
    ModuleVersion = '1.0'
    GUID = 'fbaca439-5fc5-4ac9-ab35-d371d0d1d148'
    RequiredModules = @()
    FunctionsToExport = @(
        'ConvertTo-Hashtable'
        'Get-MemberOrDefault'
        'Get-ValueOrDefault'
        'Join-Paths'
        'New-HashSlice'
        'Test-Admin'
        'Assert-Path'
    )
    AliasesToExport = @()
}
