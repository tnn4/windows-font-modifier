# Author: tnn4
# License: MIT 2023.03

# DATA
$allowed_fonts=@(
    "consolas", 
    "noto sans mono", 
    "intellij mono"
)

$reg_editor_version="Windows Registry Editor Version 5.00"

$reg_path2font="[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts]"

$segoe_default= @"
"Segoe UI (TrueType)"=""
"Segoe UI Bold (TrueType)"=""
"Segoe UI Bold Italic (TrueType)"=""
"Segoe UI Italic (TrueType)"=""
"Segoe UI Light (TrueType)"=""
"Segoe UI Semibold (TrueType)"=""
"Segoe UI Symbol (TrueType)"="seguisym.ttf"
"@

$reg_path2fontsub="[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes]"

# default
$default_font="Consolas"

# FUNCTIONS

function help {
    write-host "please enter something valid"
    exit 0
}

function iteratefonts {
    $idx = 0
    foreach ($font in $allowed_fonts){
        write-output "${idx}: $font"
        $idx += 1
    }
}

function choosefont {
    param(
        [Alias("ChooseFont")]
        [byte]$font_enum
    )
    # ./mkfontinstaller.ps1 -ChooseFont [0|1|2]
    if ($font_enum -eq 0){
        $chosen_font = $allowed_fonts[0]
    }
    elseif ($font_enum -eq 1){
        $chosen_font = $allowed_fonts[1]
    }
    elseif ($font_enum -eq 2) {
        $chosen_font = $allowed_font[2]
    }
    else {
        help
    }
    return $file="font-install-${chosen_font}.reg"
}

function writefile {
    Param(
        [Alias("FileName")]
        [string]$file
        # writefile -File
    )

    write-output $file

    $reg_editor_version="Windows Registry Editor Version 5.00"

    $reg_path2font="[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts]"

    $segoe_default= @"
    "Segoe UI (TrueType)"=""
    "Segoe UI Bold (TrueType)"=""
    "Segoe UI Bold Italic (TrueType)"=""
    "Segoe UI Italic (TrueType)"=""
    "Segoe UI Light (TrueType)"=""
    "Segoe UI Semibold (TrueType)"=""
    "Segoe UI Symbol (TrueType)"="seguisym.ttf"
"@

    $reg_path2fontsub="[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes]"
    
    Add-Content -Value $reg_editor_version -Path $file
    Add-Content -Value $reg_path2font -Path $file
    Add-Content -Value $segoe_default -Path $file
    Add-Content -Value $reg_path2fontsub -Path $file
    if ($chosen_font -eq $null){
        $chosen_font="consolas"
    }
    Add-Content -Value "`"Segoe UI`"=`"$chosen_font`"" -Path $file
}

function mkinstaller {
    write-host "Creating installer file..."
    # check if file already exists in current directory
    #If the file does not exist, create it.
    if (-not(Test-Path -Path $args[1] -PathType Leaf)) {
         try {
             $null = New-Item -ItemType File -Path $file -Force -ErrorAction Stop
             Write-Host "The file [$args[1]] has been created."
             # write to file
             writefile $args[1]
         }
         catch {
             throw $_.Exception.Message
         }
     }
    # If the file already exists, show the message and do nothing.
     else {
         Write-Host "Cannot create [$args[1]] because a file with that name already exists."
     }
}


function main {
    write-output "allowed fonts:"
    iteratefonts
    $file = choosefont
    echo "file: ${file}"
    mkinstaller -FileName $file
}

main $file