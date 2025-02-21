# Must be run as Administrator
# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator!"
    break
}

# Function to get WSL IP address
function Get-WslIpAddress {
    try {
        # Using uppercase -I as per Microsoft documentation to get the correct network-accessible IP
        $wslIp = wsl.exe hostname -I
        if ($wslIp) {
            # Trim any extra whitespace and take the first IP if multiple are returned
            $wslIp = ($wslIp.Trim() -split ' ')[0]
            if ($wslIp -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
                return $wslIp
            }
        }
        Write-Warning "Could not get valid WSL IP address. Is your WSL instance running?"
        return $null
    }
    catch {
        Write-Warning "Error getting WSL IP address: $_"
        return $null
    }
}

# Function to setup port forwarding
function Set-PortForwarding {
    param (
        [string]$wslIp,
        [int[]]$tcpPorts = @(52416, 52415),  # gRPC and API/WebUI ports
        [int[]]$udpPorts = @(5678)    # Discovery port
    )

    # Remove existing port forwarding rules
    Write-Host "Removing existing port forwarding rules..."
    $existingRules = netsh interface portproxy show all
    if ($existingRules) {
        netsh interface portproxy reset
    }

    # Add new port forwarding rules
    foreach ($port in $tcpPorts) {
        Write-Host "Setting up TCP port forwarding for port $port..."
        # Using 0.0.0.0 to listen on all interfaces as per Microsoft documentation
        $result = netsh interface portproxy add v4tov4 listenport=$port listenaddress=0.0.0.0 connectport=$port connectaddress=$wslIp
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully configured port forwarding for TCP port $port"
        } else {
            Write-Warning "Failed to configure port forwarding for TCP port $port"
        }
    }

    # Configure firewall rules
    Write-Host "Configuring firewall rules..."
    
    # Remove existing rules with the same names
    Remove-NetFirewallRule -DisplayName "WSL2 TCP*" -ErrorAction SilentlyContinue
    Remove-NetFirewallRule -DisplayName "WSL2 UDP*" -ErrorAction SilentlyContinue

    # Add TCP rules
    foreach ($port in $tcpPorts) {
        New-NetFirewallRule -DisplayName "WSL2 TCP $port" -Direction Inbound -Action Allow -Protocol TCP -LocalPort $port
    }

    # Add UDP rules
    foreach ($port in $udpPorts) {
        New-NetFirewallRule -DisplayName "WSL2 UDP $port" -Direction Inbound -Action Allow -Protocol UDP -LocalPort $port
    }
}

# Check Windows Edition
$windowsEdition = (Get-ComputerInfo).WindowsEditionId
Write-Host "Detected Windows Edition: $windowsEdition"

# Enable Windows Features based on edition
if ($windowsEdition -like "*Pro*" -or $windowsEdition -like "*Enterprise*" -or $windowsEdition -like "*Education*") {
    Write-Host "Enabling Hyper-V features..."
    try {
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell -All -NoRestart
    } catch {
        Write-Warning "Could not enable Hyper-V features. This might be expected on some systems."
    }
}

# Enable Virtual Machine Platform (required for WSL2)
Write-Host "Enabling Virtual Machine Platform..."
try {
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart
} catch {
    Write-Warning "Could not enable Virtual Machine Platform. Please ensure your Windows version supports WSL2."
    break
}

# Enable WSL feature if not already enabled
Write-Host "Ensuring WSL feature is enabled..."
try {
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart
} catch {
    Write-Warning "Could not enable WSL feature. Please check your Windows version."
    break
}

# Stop WSL
Write-Host "Shutting down WSL..."
wsl --shutdown

# Get WSL IP and setup port forwarding
$wslIp = Get-WslIpAddress
if ($wslIp) {
    Write-Host "WSL IP detected: $wslIp"
    Set-PortForwarding -wslIp $wslIp -tcpPorts @(52416, 52415) -udpPorts @(5678)
    
    # Display the current port proxy configuration
    Write-Host "`nCurrent port proxy configuration:"
    netsh interface portproxy show all
} else {
    Write-Warning "Could not detect WSL IP address. Please ensure WSL is running and try again."
}

Write-Host "`nConfiguration complete! Please follow these steps:"
Write-Host "1. If this is your first time running the script, restart your computer"
Write-Host "2. Start your WSL instance with 'wsl'"
Write-Host "3. Run this script again to configure port forwarding"
Write-Host "4. Verify your WSL IP with 'wsl hostname -I'"
Write-Host "5. Verify port forwarding with 'netsh interface portproxy show all'"
Write-Host "`nTo verify WSL connectivity from another machine on your network:"
Write-Host "1. Get your Windows host IP address"
Write-Host "2. Try to connect to that IP using one of the configured ports"
Write-Host "3. Required ports:"
Write-Host "   - UDP 5678: Discovery service"
Write-Host "   - TCP 52416: gRPC service"
Write-Host "   - TCP 52415: API/WebUI (optional)"