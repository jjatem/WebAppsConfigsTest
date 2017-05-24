## Define aliases for path testing
function not-exist { -not (Test-Path $args) }
Set-Alias !exist not-exist -Force -Option "ReadOnly, AllScope"
Set-Alias exist Test-Path -Force -Option "ReadOnly, AllScope"

## Variables definition
$git_download_url = "https://github.com/git-for-windows/git/releases/download/v2.13.0.windows.1/Git-2.13.0-64-bit.exe"
$git_clone_repo_url = "https://github.com/jjatem/WebAppsConfigsTest.git"
$git_install_file = "C:\Temp\Git-2.13.0-64-bit.exe"
$git_install_path = "C:\Program Files (x86)\Git\bin"
$git_clone_main_path = "C:\GitClone"
$GitRepoName = "WebAppsConfigsTest"

$ini_file_name = "c:\Temp\GitInstall.ini"
$ini_file_contents = 
"[Setup]
Lang=default
Dir=C:\Program Files (x86)\Git
Group=Git
NoIcons=0
SetupType=default
Components=
Tasks=
PathOption=Cmd
SSHOption=OpenSSH
CRLFOption=CRLFAlways"

## Set Execution Policy
Set-ExecutionPolicy Unrestricted

## First Download Git Software to C:\temp if it hasn't been already downloaded

if (not-exist $git_install_file)
{
    Invoke-WebRequest -Uri $git_download_url -OutFile $git_install_file
}

## Create .ini install file for unattended install

New-Item $ini_file_name -type File -Force -Value $ini_file_contents

## Kick off unattended installation in case git is not already installed

if (not-exist $git_install_path)
{
    $command = "cmd.exe /c " + $git_install_file + " /SILENT /COMPONENTS=`"icons,ext\reg\shellhere,assoc,assoc_sh`"" + " /LOADINF=" + $ini_file_name
    Invoke-Expression $command
}

## Create Git folder for Git Clone
New-Item $git_clone_main_path -type Directory -Force

## Set Location to GitClone
Set-Location $git_clone_main_path

##purge cloned repo if it exists prior cloning again
$CheckPath = $git_clone_main_path + "\" + $GitRepoName

if (exist $CheckPath)
{
    Remove-Item $CheckPath -Force -Recurse
}

## Clone/pull repo from Git

$GitCommand = "git"
$ArgumentList = " clone " + $git_clone_repo_url

Start-Process -FilePath $GitCommand -ArgumentList $ArgumentList -Wait
Write-Host "Successfully cloned" $GitRepoName

## Set Execution Policy
Set-ExecutionPolicy RemoteSigned