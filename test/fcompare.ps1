$file1="font-install-consolas.reg"
$file2="install-fonts.reg"

if ((Get-FileHash $file1).Hash -eq (Get-FileHash $file2).Hash){
    echo "files same"
}
else {
    echo "[ERROR] Not the same"
}