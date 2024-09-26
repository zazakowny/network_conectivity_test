#!/bin/bash

# List of subdomains to check for NTP
subdomains=("ntp.ubuntu.com" "time.google.com" "pool.ntp.org")

# HTTP servers to check
http_servers=("security.ubuntu.com" "archive.ubuntu.com")

# SSL servers to check
ssl_servers=("ekoinfolab.pl" "pega.com")


# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color (reset)

# Function to test if an interface is up
is_interface_up() {
    local iface=$1
    ip link show "$iface" | grep -q "state UP"
}

# Function to check if interface has an IP address
is_interface_connected() {
    local iface=$1
    ip -4 addr show "$iface" | grep -q "inet"
}

# Function to check internet connectivity (by pinging Google DNS)
has_internet_access() {
    ping -q -c 1 -W 1 8.8.8.8 > /dev/null 2>&1
}

# Function to check NTP server availability on port 123 for multiple subdomains
can_connect_to_ntp() {
    for subdomain in "${subdomains[@]}"; do
        if nc -z -w 1 "$subdomain" 123 > /dev/null 2>&1; then
            echo -e "  ${GREEN}PASS${NC} NTP: Connection to $subdomain (port 123) is available"
        else
            echo -e "  ${RED}FAIL${NC} NTP: Unable to connect to $subdomain on port 123"
        fi
    done
}

# Function to test HTTP connection to specific servers on port 80
check_http_connection() {
    for server in "${http_servers[@]}"; do
    #    echo "  Testing HTTP for $server..."
        if nc -z -w 5 "$server" 80 > /dev/null 2>&1; then
            echo -e "  ${GREEN}PASS${NC} HTTP: Port 80 on $server is open and accessible"
        else
            echo -e "  ${RED}FAIL${NC} HTTP: Unable to connect to $server on port 80"
        fi
    done
}


# Function to test SSL connection to specific servers on port 443
check_ssl_connection() {
    for server in "${ssl_servers[@]}"; do
    #    echo "  Testing SSL for $server..."
        if timeout 5s openssl s_client -connect "$server":443 -servername "$server" < /dev/null 2>/dev/null | grep -q "Verify return code: 0 (ok)"; then
            echo -e "  ${GREEN}PASS${NC} SSL: Secure connection to $server is available"
        else
            echo -e "  ${RED}FAIL${NC} SSL: Unable to establish a secure connection to $server"
        fi
    done
}
# Get list of network interfaces
interfaces=$(ls /sys/class/net)

echo "Checking network interfaces..."
echo

# Loop through all interfaces
for iface in $interfaces; do
    echo -e "Interface: ${YELLOW}$iface${NC}"

    # Check if the interface is up
    if is_interface_up "$iface"; then
        echo -e "  Status: ${GREEN}UP${NC}"

        # Check if the interface has an IP (i.e., is connected)
        if is_interface_connected "$iface"; then
            echo -e "  Connection: ${GREEN}Connected${NC}"

            # Check if the interface has internet access
            if has_internet_access; then
                echo -e "  Internet:  ${GREEN}Yes${NC}"
            else
                echo -e "  Internet:  ${RED}No${NC}"
            fi

            # Check if the interface can connect to multiple NTP subdomains on port 123
            can_connect_to_ntp

            # Test HTTP connection to security.ubuntu.com and archive.ubuntu.com
            check_http_connection

            # Test SSL connection to security.ubuntu.com and archive.ubuntu.com
            check_ssl_connection

        else
            echo "  Connection: Disconnected"
        fi
    else
        echo -e "  Status:  ${RED}DOWN${NC}"
    fi

    echo
done
