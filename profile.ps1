function prompt {
  $realLASTEXITCODE = $LASTEXITCODE

  Write-Host

  # Reset color, which can be messed up by Enable-GitColors
  #$Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

  if (Test-Administrator) {
    # Use different username if elevated
    Write-Host "(Elevated) " -NoNewline -ForegroundColor White
  }

  Write-Host "$ENV:USERNAME@" -NoNewline -ForegroundColor DarkYellow
  Write-Host "$ENV:COMPUTERNAME " -NoNewline -ForegroundColor Magenta

  if ($s -ne $null) {
    # color for PSSessions
    Write-Host " (`$s: " -NoNewline -ForegroundColor DarkGray
    Write-Host "$($s.Name)" -NoNewline -ForegroundColor Yellow
    Write-Host ") " -NoNewline -ForegroundColor DarkGray
  }

  #Write-Host " : " -NoNewline -ForegroundColor DarkGray
  Write-Host $($(Get-Location) -replace ($env:USERPROFILE).Replace('\', '\\'), "~") -NoNewline -ForegroundColor Green
  #Write-Host " : " -NoNewline -ForegroundColor DarkGray

  $global:LASTEXITCODE = $realLASTEXITCODE

    #PS thing?
  #Write-VcsStatus

  Write-Host " " -NoNewline

  return "> "
}

#Install-Module posh-docker -Scope CurrentUser

function Test-Administrator {
  $user = [Security.Principal.WindowsIdentity]::GetCurrent();
  (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Start-Administrator {
  Start-Process powershell -verb RunAs
}

#aliases
Set-Alias elevate Start-Administrator #starts a new session as admin, as close to sudo you can get.
#Set-Alias code code-insiders.cmd #aliases the insiders version of code cli

if (Test-Administrator) {
  (Get-Host).UI.RawUI.BackgroundColor = "DarkRed"
  Clear-Host
  Write-Host "Warning: PowerShell is running as an Administrator.`n"
}
#else 
#{
#    (Get-Host).UI.RawUI.BackgroundColor = 'Black'
#    (Get-Host).UI.RawUI.ForegroundColor = 'Green'
#    Clear-Host
#}

#Write-Host "Calculating the ultimate answer to life, the universe and everything..... Plz wait..."  

if (Test-Path $env:LOCALAPPDATA\GitHub\) {
  . $env:LOCALAPPDATA\GitHub\shell.ps1
  . $env:github_posh_git\profile.example.ps1
}

$env:Path = "$env:Path;.bin" 

if (Test-Path c:\src) {
  Set-Location c:\src
}

function NukeDockerStuff() {
  docker rm $(docker ps -aq) -f
  docker volumes prune
  Clear-Host
}


#Write-Output "Answer: 42"

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
