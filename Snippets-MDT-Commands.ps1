# Connect to MDT share
Import-Module "$env:ProgramFiles\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "\\mcfly\Deployment\Automata"

# Updating boot images
Update-MDTDeploymentShare -path "DS001:" -Force -Verbose

# New task sequence
import-mdttasksequence -path "DS001:\Task Sequences\Vanilla OS" -Name "Windows Server" -Template "Server.xml" -Comments "" -ID "001" -Version "1.0" -OperatingSystemPath "DS002:\Operating Systems\Volume License\Windows Server 2012\Windows Server 2012 SERVERSTANDARDCORE in Windows Server 2012 VL install.wim" -FullName "stealthpuppy" -OrgName "stealthpuppy" -HomePage "about:blank" -Verbose

# Remove a folder
remove-item -path "DS001:\Operating Systems\Volume License\Windows Server 2012" -force -verbose -recurse

# Import a WIM
import-mdtoperatingsystem -path "DS001:\Operating Systems\Reference Images" -SourceFile "\\mcfly\Deployment\Reference\Captures\WindowsServer2012R2-April2016.wim" -DestinationFolder "WindowsServer2012R2-April2016" -Move -Verbose

# Remove all operating systems of x86 architecture
# (still need to fix exact syntax)
Get-ChildItem -Recurse -Include *.wim | Where-Object { $_.Platform -eq "x86" } | ForEach { Remove-Item $_.PSPath -Force -Verbose }
