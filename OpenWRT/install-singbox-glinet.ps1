[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [Alias('Host')]
    [string]$TargetHost,

    [string]$User = 'root',

    [int]$Port = 22,

    [string]$IdentityFile,

    [string[]]$SshOption = @(),

    [string]$PackagePath,

    [string]$PackageUrl,

    [string]$Version = '1.12.17',

    [string]$Architecture = 'openwrt_aarch64_cortex-a53',

    [string]$ConfigPath,

    [string[]]$HotplugInterface = @('wan', 'tethering'),

    [int]$TProxyPort = 6452
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSVersion.Major -lt 6) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}

if ($PackagePath -and $PackageUrl) {
    throw 'PackagePath and PackageUrl cannot be used together.'
}

if ($PackagePath -and $Version) {
    throw 'PackagePath and Version cannot be used together.'
}

if ($PackageUrl -and $Version) {
    throw 'PackageUrl and Version cannot be used together.'
}

if (-not $HotplugInterface -or $HotplugInterface.Count -eq 0) {
    throw 'At least one HotplugInterface must be specified.'
}

if ($Port -lt 1 -or $Port -gt 65535) {
    throw 'Port must be between 1 and 65535.'
}

if ($TProxyPort -lt 1 -or $TProxyPort -gt 65535) {
    throw 'TProxyPort must be between 1 and 65535.'
}

function Resolve-CommandPath {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Names
    )

    foreach ($name in $Names) {
        $command = Get-Command -Name $name -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not $command) {
            continue
        }

        if ($command.Path) {
            return $command.Path
        }

        if ($command.Source) {
            return $command.Source
        }

        if ($command.Definition) {
            return $command.Definition
        }

        return $command.Name
    }

    throw ('Unable to resolve command path for: {0}' -f ([string]::Join(', ', $Names)))
}

$target = '{0}@{1}' -f $User, $TargetHost
$sshPath = Resolve-CommandPath -Names @('ssh.exe', 'ssh')
$scpPath = Resolve-CommandPath -Names @('scp.exe', 'scp')
$workDir = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ('sing-box-install-' + [guid]::NewGuid().ToString('N'))

if ($IdentityFile) {
    $IdentityFile = (Resolve-Path -LiteralPath $IdentityFile).Path
}

if ($ConfigPath) {
    $ConfigPath = (Resolve-Path -LiteralPath $ConfigPath).Path
}

New-Item -ItemType Directory -Path $workDir | Out-Null

function Write-Step {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Host ('==> {0}' -f $Message)
}

function Write-Utf8NoBomFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$Content
    )

    $encoding = New-Object System.Text.UTF8Encoding($false)
    $normalizedContent = $Content -replace "`r`n", "`n" -replace "`r", "`n"
    [System.IO.File]::WriteAllText($Path, $normalizedContent, $encoding)
}

function Invoke-DownloadFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Uri,

        [Parameter(Mandatory = $true)]
        [string]$OutFile
    )

    $parameters = @{
        Uri = $Uri
        OutFile = $OutFile
    }

    if ($PSVersionTable.PSVersion.Major -lt 6) {
        $parameters.UseBasicParsing = $true
    }

    Invoke-WebRequest @parameters
}

function Invoke-ExternalCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(Mandatory = $true)]
        [string[]]$Arguments,

        [Parameter(Mandatory = $true)]
        [string]$Description
    )

    Write-Step -Message $Description
    & $FilePath @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw ('{0} failed with exit code {1}.' -f $Description, $LASTEXITCODE)
    }
}

function Get-SshCommonArguments {
    $arguments = @()

    if ($Port -ne 22) {
        $arguments += @('-p', $Port.ToString())
    }

    if ($IdentityFile) {
        $arguments += @('-i', $IdentityFile)
    }

    foreach ($option in $SshOption) {
        $arguments += @('-o', $option)
    }

    return $arguments
}

function Get-ScpCommonArguments {
    $arguments = @('-O')

    if ($Port -ne 22) {
        $arguments += @('-P', $Port.ToString())
    }

    if ($IdentityFile) {
        $arguments += @('-i', $IdentityFile)
    }

    foreach ($option in $SshOption) {
        $arguments += @('-o', $option)
    }

    return $arguments
}

function Invoke-Ssh {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Command,

        [Parameter(Mandatory = $true)]
        [string]$Description
    )

    $arguments = @(Get-SshCommonArguments)
    $arguments += $target
    $arguments += $Command
    Invoke-ExternalCommand -FilePath $sshPath -Arguments $arguments -Description $Description
}

function Copy-ToRemote {
    param(
        [Parameter(Mandatory = $true)]
        [string]$LocalPath,

        [Parameter(Mandatory = $true)]
        [string]$RemotePath,

        [Parameter(Mandatory = $true)]
        [string]$Description
    )

    $arguments = @(Get-ScpCommonArguments)
    $arguments += $LocalPath
    $arguments += ('{0}:{1}' -f $target, $RemotePath)
    Invoke-ExternalCommand -FilePath $scpPath -Arguments $arguments -Description $Description
}

function Get-GitHubRelease {
    param(
        [string]$RequestedVersion
    )

    $releaseUri = if ($RequestedVersion) {
        'https://api.github.com/repos/SagerNet/sing-box/releases/tags/v{0}' -f $RequestedVersion
    }
    else {
        'https://api.github.com/repos/SagerNet/sing-box/releases/latest'
    }

    Write-Step -Message ('Querying GitHub release metadata from {0}' -f $releaseUri)
    return Invoke-RestMethod -Uri $releaseUri -Headers @{ 'User-Agent' = 'PowerShell' }
}

function Find-SingBoxAsset {
    param(
        [Parameter(Mandatory = $true)]
        [object[]]$Assets,

        [Parameter(Mandatory = $true)]
        [string]$RequestedArchitecture
    )

    $normalizedArchitecture = $RequestedArchitecture.ToLowerInvariant() -replace '[^a-z0-9]+', '_'
    $normalizedArchitecture = $normalizedArchitecture -replace '^openwrt_', ''
    $segments = @($normalizedArchitecture -split '_') | Where-Object { $_ }
    $candidateAssets = @()

    foreach ($asset in $Assets) {
        $assetName = [string]$asset.name
        $assetNameLower = $assetName.ToLowerInvariant()
        if ($assetNameLower -notmatch '\.ipk$') {
            continue
        }

        if ($assetNameLower -notmatch 'openwrt') {
            continue
        }

        $normalizedAssetName = $assetNameLower -replace '[^a-z0-9]+', '_'
        $allSegmentsMatched = $true

        foreach ($segment in $segments) {
            if ($normalizedAssetName -notmatch [regex]::Escape($segment)) {
                $allSegmentsMatched = $false
                break
            }
        }

        if (-not $allSegmentsMatched) {
            continue
        }

        $score = 0
        if ($normalizedAssetName -match [regex]::Escape('openwrt_' + $normalizedArchitecture)) {
            $score += 20
        }

        if ($normalizedAssetName -match [regex]::Escape($normalizedArchitecture)) {
            $score += 10
        }

        $candidateAssets += [PSCustomObject]@{
            Score = $score
            Asset = $asset
        }
    }

    if (-not $candidateAssets) {
        throw ('No sing-box release asset matched architecture "{0}".' -f $RequestedArchitecture)
    }

    return ($candidateAssets | Sort-Object -Property Score -Descending | Select-Object -First 1).Asset
}

function Resolve-PackageFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DestinationDirectory
    )

    if ($PackagePath) {
        $resolvedPackagePath = (Resolve-Path -LiteralPath $PackagePath).Path
        return [PSCustomObject]@{
            LocalPath = $resolvedPackagePath
            Source = $resolvedPackagePath
        }
    }

    $downloadUri = $PackageUrl
    $downloadName = $null

    if (-not $downloadUri) {
        $release = Get-GitHubRelease -RequestedVersion $Version
        $asset = Find-SingBoxAsset -Assets $release.assets -RequestedArchitecture $Architecture
        $downloadUri = $asset.browser_download_url
        $downloadName = $asset.name
    }
    else {
        $downloadName = [System.IO.Path]::GetFileName(([Uri]$downloadUri).AbsolutePath)
        if (-not $downloadName) {
            $downloadName = 'sing-box.ipk'
        }
    }

    $destinationPath = Join-Path -Path $DestinationDirectory -ChildPath $downloadName
    Write-Step -Message ('Downloading package from {0}' -f $downloadUri)
    Invoke-DownloadFile -Uri $downloadUri -OutFile $destinationPath

    return [PSCustomObject]@{
        LocalPath = $destinationPath
        Source = $downloadUri
    }
}

function New-TProxyScriptContent {
    param(
        [Parameter(Mandatory = $true)]
        [int]$PortNumber
    )

    return @"
#!/bin/sh
TPROXY_PORT=$PortNumber

do_stop() {
    echo "Cleaning up TProxy rules..."
    while iptables -t mangle -D PREROUTING -j SING_BOX 2>/dev/null; do :; done
    iptables -t mangle -F SING_BOX 2>/dev/null
    iptables -t mangle -X SING_BOX 2>/dev/null
    while ip rule del fwmark 1 table 100 2>/dev/null; do :; done
    while ip route del local 0.0.0.0/0 dev lo table 100 2>/dev/null; do :; done
}

do_start() {
    do_stop
    echo "Applying TProxy rules..."

    iptables -t mangle -N SING_BOX
    iptables -t mangle -A SING_BOX -d 0.0.0.0/8 -j RETURN
    iptables -t mangle -A SING_BOX -d 127.0.0.0/8 -j RETURN
    iptables -t mangle -A SING_BOX -d 10.0.0.0/8 -j RETURN
    iptables -t mangle -A SING_BOX -d 100.64.0.0/10 -j RETURN
    iptables -t mangle -A SING_BOX -d 172.16.0.0/12 -j RETURN
    iptables -t mangle -A SING_BOX -d 192.168.0.0/16 -j RETURN
    iptables -t mangle -A SING_BOX -d 224.0.0.0/4 -j RETURN
    iptables -t mangle -A SING_BOX -d 255.255.255.255/32 -j RETURN
    iptables -t mangle -A SING_BOX -p tcp -j TPROXY --on-port `$TPROXY_PORT --tproxy-mark 1
    iptables -t mangle -A SING_BOX -p udp -j TPROXY --on-port `$TPROXY_PORT --tproxy-mark 1
    iptables -t mangle -A PREROUTING -j SING_BOX

    ip rule add fwmark 1 table 100
    ip route add local 0.0.0.0/0 dev lo table 100
    echo "TProxy rules applied successfully."
}

case "`$1" in
    stop)
        do_stop
        ;;
    start|*)
        do_start
        ;;
esac
"@
}

function New-HotplugScriptContent {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Interfaces
    )

    $conditions = foreach ($interface in $Interfaces) {
        $cleanInterface = $interface.Replace('"', '')
        "[ `"`$INTERFACE`" = `"$cleanInterface`" ]"
    }

    $conditionText = [string]::Join(' || ', $conditions)

    return @"
#!/bin/sh

if [ "`$ACTION" = "ifup" ]; then
    if $conditionText; then
        logger -t sing-box "`$INTERFACE is up, restarting sing-box..."
        /etc/init.d/sing-box restart
    fi
fi
"@
}

function New-RemoteInstallScriptContent {
    return @'
#!/bin/sh

set -eu

PACKAGE_FILE="/tmp/sing-box-package.ipk"
TPROXY_FILE="/tmp/sing-box-tproxy.sh"
HOTPLUG_FILE="/tmp/99-sing-box"
CONFIG_FILE="/tmp/sing-box-config.json"
WORKDIR="/tmp/sing-box-install.$$"
INIT_FILE="/etc/init.d/sing-box"
TARGET_TPROXY="/etc/sing-box/tproxy.sh"
TARGET_HOTPLUG="/etc/hotplug.d/iface/99-sing-box"
TARGET_CONFIG="/etc/sing-box/config.json"
CONFIG_BACKUP="$WORKDIR/config.json.backup"
INSTALL_SCRIPT="/tmp/install-singbox-glinet.sh"

cleanup() {
    rm -rf "$WORKDIR"
    rm -f "$PACKAGE_FILE" "$TPROXY_FILE" "$HOTPLUG_FILE" "$CONFIG_FILE" "$INSTALL_SCRIPT"
}

trap cleanup EXIT INT TERM

require_file() {
    if [ ! -f "$1" ]; then
        echo "Missing required file: $1" >&2
        exit 1
    fi
}

patch_init_script() {
    init_file="$1"
    tmp_file="$WORKDIR/sing-box.init.tmp"

    if ! grep -q '^TPROXY_SCRIPT="/etc/sing-box/tproxy.sh"$' "$init_file"; then
        if ! awk '
            BEGIN { inserted = 0 }
            /^PROG="\/usr\/bin\/sing-box"$/ {
                print
                print "TPROXY_SCRIPT=\"/etc/sing-box/tproxy.sh\""
                inserted = 1
                next
            }
            { print }
            END { if (!inserted) exit 1 }
        ' "$init_file" > "$tmp_file"; then
            rm -f "$tmp_file"
            echo "Failed to patch sing-box init script: PROG line not found." >&2
            exit 1
        fi
        mv "$tmp_file" "$init_file"
    fi

    if ! grep -q '/bin/sh "\$TPROXY_SCRIPT" start' "$init_file"; then
        if ! awk '
            BEGIN { in_start = 0; inserted = 0 }
            /^start_service\(\) \{/ { in_start = 1 }
            in_start && !inserted && /^}$/ {
                print "  if [ -f \"$TPROXY_SCRIPT\" ]; then"
                print "    /bin/sh \"$TPROXY_SCRIPT\" start"
                print "  fi"
                inserted = 1
            }
            { print }
            in_start && /^}$/ { in_start = 0 }
            END { if (!inserted) exit 1 }
        ' "$init_file" > "$tmp_file"; then
            rm -f "$tmp_file"
            echo "Failed to patch sing-box init script: start_service block not found." >&2
            exit 1
        fi
        mv "$tmp_file" "$init_file"
    fi

    if ! grep -q '^stop_service() {$' "$init_file"; then
        if ! awk '
            BEGIN { inserted = 0 }
            /^service_triggers\(\) \{/ && !inserted {
                print "stop_service() {"
                print "  if [ -f \"$TPROXY_SCRIPT\" ]; then"
                print "    /bin/sh \"$TPROXY_SCRIPT\" stop"
                print "  fi"
                print "}"
                print ""
                print "reload_service() {"
                print "  stop_service"
                print "  start_service"
                print "}"
                print ""
                inserted = 1
            }
            { print }
            END {
                if (!inserted) {
                    print ""
                    print "stop_service() {"
                    print "  if [ -f \"$TPROXY_SCRIPT\" ]; then"
                    print "    /bin/sh \"$TPROXY_SCRIPT\" stop"
                    print "  fi"
                    print "}"
                    print ""
                    print "reload_service() {"
                    print "  stop_service"
                    print "  start_service"
                    print "}"
                }
            }
        ' "$init_file" > "$tmp_file"; then
            rm -f "$tmp_file"
            echo "Failed to append sing-box stop and reload hooks." >&2
            exit 1
        fi
        mv "$tmp_file" "$init_file"
    fi

    chmod 755 "$init_file"
}

require_file "$PACKAGE_FILE"
require_file "$TPROXY_FILE"
require_file "$HOTPLUG_FILE"

mkdir -p "$WORKDIR" /etc/sing-box /etc/hotplug.d/iface

if [ -f "$TARGET_CONFIG" ] && [ ! -f "$CONFIG_FILE" ]; then
    cp "$TARGET_CONFIG" "$CONFIG_BACKUP"
fi

/etc/init.d/sing-box stop >/dev/null 2>&1 || true
if [ -f "$TARGET_TPROXY" ]; then
    /bin/sh "$TARGET_TPROXY" stop >/dev/null 2>&1 || true
fi

tar -xzf "$PACKAGE_FILE" -C "$WORKDIR"
require_file "$WORKDIR/data.tar.gz"
tar -xzf "$WORKDIR/data.tar.gz" -C /

cp "$TPROXY_FILE" "$TARGET_TPROXY"
chmod 755 "$TARGET_TPROXY"

cp "$HOTPLUG_FILE" "$TARGET_HOTPLUG"
chmod 755 "$TARGET_HOTPLUG"

if [ -f "$CONFIG_FILE" ]; then
    cp "$CONFIG_FILE" "$TARGET_CONFIG"
    chmod 600 "$TARGET_CONFIG"
elif [ -f "$CONFIG_BACKUP" ]; then
    cp "$CONFIG_BACKUP" "$TARGET_CONFIG"
fi

require_file "$INIT_FILE"
patch_init_script "$INIT_FILE"

if [ -x /usr/bin/sing-box ] && [ -f "$TARGET_CONFIG" ]; then
    /usr/bin/sing-box check -c "$TARGET_CONFIG"
fi

/etc/init.d/sing-box disable >/dev/null 2>&1 || true

if /etc/init.d/sing-box restart; then
    echo "sing-box installation completed."
else
    echo "sing-box installation completed, but restart failed. 99-sing-box will retry on interface ifup." >&2
fi
'@
}

try {
    $package = Resolve-PackageFile -DestinationDirectory $workDir
    $tproxyScriptPath = Join-Path -Path $workDir -ChildPath 'sing-box-tproxy.sh'
    $hotplugScriptPath = Join-Path -Path $workDir -ChildPath '99-sing-box'
    $remoteInstallScriptPath = Join-Path -Path $workDir -ChildPath 'install-singbox-glinet.sh'

    Write-Utf8NoBomFile -Path $tproxyScriptPath -Content (New-TProxyScriptContent -PortNumber $TProxyPort)
    Write-Utf8NoBomFile -Path $hotplugScriptPath -Content (New-HotplugScriptContent -Interfaces $HotplugInterface)
    Write-Utf8NoBomFile -Path $remoteInstallScriptPath -Content (New-RemoteInstallScriptContent)

    $remoteFiles = @(
        [PSCustomObject]@{ Local = $package.LocalPath; Remote = '/tmp/sing-box-package.ipk'; Description = 'Uploading sing-box package' },
        [PSCustomObject]@{ Local = $tproxyScriptPath; Remote = '/tmp/sing-box-tproxy.sh'; Description = 'Uploading TProxy helper script' },
        [PSCustomObject]@{ Local = $hotplugScriptPath; Remote = '/tmp/99-sing-box'; Description = 'Uploading hotplug startup script' },
        [PSCustomObject]@{ Local = $remoteInstallScriptPath; Remote = '/tmp/install-singbox-glinet.sh'; Description = 'Uploading remote installer script' }
    )

    if ($ConfigPath) {
        $remoteFiles += [PSCustomObject]@{ Local = $ConfigPath; Remote = '/tmp/sing-box-config.json'; Description = 'Uploading sing-box config' }
    }
    else {
        Invoke-Ssh -Command 'rm -f /tmp/sing-box-config.json' -Description 'Removing stale remote config upload'
    }

    foreach ($remoteFile in $remoteFiles) {
        Copy-ToRemote -LocalPath $remoteFile.Local -RemotePath $remoteFile.Remote -Description $remoteFile.Description
    }

    Invoke-Ssh -Command 'sh /tmp/install-singbox-glinet.sh' -Description 'Running remote sing-box installer'

    Write-Host ''
    Write-Host ('Target : {0}' -f $target)
    Write-Host ('Package: {0}' -f $package.Source)
    if ($ConfigPath) {
        Write-Host ('Config : {0}' -f $ConfigPath)
    }
    else {
        Write-Host 'Config : keep existing remote /etc/sing-box/config.json'
    }
}
finally {
    if (Test-Path -LiteralPath $workDir) {
        Remove-Item -LiteralPath $workDir -Recurse -Force
    }
}