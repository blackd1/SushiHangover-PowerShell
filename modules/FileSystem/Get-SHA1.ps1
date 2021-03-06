function Get-SHA1
{
    <#
    .Synopsis
    Computes the SHA1 hash of the specified file.

    .Description
    The Get-SHA1 function creates a cryptographic hash of the file
    specified in the File parameter by using the SHA1 method.

    .Outputs
    Returns a System.Object with an SHA1 property that contains
    the hash value in a string.
    
    .Parameter File

    Enter a path (optional) and name for the file.
    You can enter multiple files by piping the output of 
    Get-ChildItem into Get-SHA1
     
    The file name is required. The default path is
    the current directory.    
        
    .Example
    get-SHA1 –file Stats.xlsx

    .Example
    get-SHA1 c:\ps-test\Stats.xlsx

    .Example
    $hash = (get-SHA1 –file Stats.xlsx).sha1
    #>

    param(
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [Alias("FullName")]
    [string]
    $File
    )
    
    Begin {
        $sha1 = [Security.Cryptography.SHA1]::Create()
    }
    
    Process {
        $realFile = Get-Item $file
        if (-not $realFile.PSIsContainer) {
            $sha1Hash = [Convert]::ToBase64String(
                $sha1.ComputeHash([IO.File]::ReadAllBytes($realFile.FullName))
            )
            New-Object Object |
                Add-Member NoteProperty File $realFile -PassThru |
                Add-Member NoteProperty SHA1 $sha1Hash -PassThru
        }
    }    
}