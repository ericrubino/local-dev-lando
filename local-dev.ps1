param (
    [switch]$quiet,
    [switch]$resetWsl,
    [string]$fullName,
    [string]$email
)

if (!$fullName) {
    $fullName = Read-Host "Enter your full name: "
}

if (!$email) {
    $email = Read-Host "Enter your email address: "
}

$windowsUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")[1]

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isAdmin) {
    Write-Host "Enabling Windows Subsystem for Linux and Virtual Machine Platform features..."
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All
} else {
    Write-Host "If you run into issues, make sure you have the VirtualMachinePlatform and Microsoft-Windows-Subsystem-Linux features enabled and run the script again.`n"
}

Write-Host "Installing PowerShell..."
winget install Microsoft.PowerShell
Write-Host ""

Write-Host "Installing Git for Windows..."
winget install Git.Git

Write-Host "Configuring Git..."
$gitPath = "C:\Users\$windowsUser\AppData\Local\Programs\Git\cmd\git.exe"
& $gitPath config --global user.name "$fullName" | out-null
& $gitPath config --global user.email "$email" | out-null
Write-Host ""

Write-Host "Installing Visual Studio Code..."
winget install Microsoft.VisualStudioCode

$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

$extensions = @(
    "ms-vscode.vscode-node-azure-pack",
    "mrmlnc.vscode-apache",
    "atlassian.atlascode",
    "formulahendry.auto-close-tag",
    "formulahendry.auto-rename-tag",
    "ms-azuretools.vscode-azureresourcegroups",
    "streetsidesoftware.code-spell-checker",
    "DEVSENSE.composer-php-vscode",
    "ms-azuretools.vscode-containers",
    "ms-vscode-remote.remote-containers",
    "ms-azuretools.vscode-docker",
    "docker.docker",
    "stanislav.vscode-drupal",
    "EditorConfig.EditorConfig",
    "DmitryDorofeev.empty-indent",
    "eamodio.gitlens",
    "oderwat.indent-rainbow",
    "devsense.intelli-php-vscode",
    "christian-kohler.path-intellisense",
    "devsense.phptools-vscode",
    "devsense.profiler-php-vscode",
    "ms-vscode.powershell",
    "mechatroner.rainbow-csv",
    "ms-vscode-remote.remote-ssh",
    "ms-vscode-remote.remote-ssh-edit",
    "ms-vscode.remote-explorer",
    "spmeesseman.vscode-taskexplorer",
    "rangav.vscode-thunder-client",
    "Gruntfuggly.todo-tree",
    "BriteSnow.vscode-toggle-quotes",
    "mblode.twig-language-2",
    "vscode-icons-team.vscode-icons",
    "ms-vscode-remote.remote-wsl",
    "DotJoshJohnson.xml",
    "redhat.vscode-yaml",
    "Atlassian.atlascode"
)

foreach ($extension in $extensions) {
    Write-Host "Installing extension $extension..."
    code --install-extension "$extension" | out-null
}

Write-Host "Updating extensions..."
code --update-extensions
Write-Host ""

Write-Host "Installing Windows Terminal..."
winget install Microsoft.WindowsTerminal
Write-Host ""

$WslDistroName = "Ubuntu"

wsl --set-default-version 2 | out-null
wsl -l |Where-Object {$_.Replace("`0","") -match "^$WslDistroName"} -outvariable WslDistroResult | out-null

if ($WslDistroResult) {
    if (!$resetWsl -and !$quiet) {
        $confirmation = Read-Host "Would you like to delete your existing $WslDistroName instance and start over (Y/[N])? "
        $resetWsl = ($confirmation -eq 'y')
    }

    if ($resetWsl) {
        Write-Host "Deleting existing $WslDistroName instance..."
        wsl --terminate $WslDistroName | out-null
        wsl --unregister $WslDistroName | out-null
        $WslDistroResult = $null
    } else {
        wsl --set-version $WslDistroName 2 | out-null
    }
}

if (-not $WslDistroResult) {
    Write-Host "Installing $WslDistroName..."
    Write-Host "Note: Please log out of the Linux terminal after WSL finishes installing to continue this script."
    wsl --install -d $WslDistroName | out-null
}

wsl --setdefault $WslDistroName | out-null
Read-Host -Prompt "Press Enter after WSL is fully installed to continue"

bash ./lib/sudo.sh

wsl --shutdown | out-null

bash ./lib/basic.sh "$windowsUser" "$fullName" "$email"

Write-Host "Installing the Ubuntu version of Docker and Lando..."
bash ./lib/docker.sh
bash ./lib/lando.sh

Write-Host "Local dev setup complete. Re-run if there are any issues."
