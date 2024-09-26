# Network Features Testing Script

This Bash script tests various network-related features for all network interfaces on the system. It checks if interfaces are up, connected, and if they have internet access. Additionally, it tests the availability of network services, such as NTP and HTTP/HTTPS, and checks SSL connections.

## Features

   * Interface Status: Checks if network interfaces are up or down.
   * Connectivity Check: Verifies if an interface has an IP address (connected).
   * Internet Access: Tests internet connectivity by pinging Google's DNS (8.8.8.8).
   * NTP (Network Time Protocol): Tests connectivity to NTP servers on port 123 for multiple subdomains.
   * SSL Test: Checks SSL connections on port 443 to specified servers (e.g., security.ubuntu.com and archive.ubuntu.com).
   * HTTP Test: Checks HTTP connections on port 80 to specified servers.
   * Colored Output: Uses colored output (green for success, red for failure) to highlight test results.

# Prerequisites

  * Bash: Ensure you are using Bash as the shell.
  * Netcat (nc): Used to check open ports for HTTP and NTP.
  * OpenSSL (openssl): Used to test SSL connections.

# Installation

  Clone the repository or download the script directly.
  
    git clone https://github.com/zazakowny/network_conectivity_test/
    
  Make the script executable:

    chmod +x check_interfaces.sh

# Usage

  Run the script directly from the terminal:

    ./check_interfaces.sh

  The script will check the status of all network interfaces on the system and output the results for each interface.

# Example output

    Checking network interfaces...

    Interface: eth0
      Status: UP
      Connection: Connected
      Internet:  Yes
      FAIL NTP: Unable to connect to ntp.ubuntu.com on port 123
      FAIL NTP: Unable to connect to time.google.com on port 123
      FAIL NTP: Unable to connect to pool.ntp.org on port 123
      PASS HTTP: Port 80 on security.ubuntu.com is open and accessible
      PASS HTTP: Port 80 on archive.ubuntu.com is open and accessible
      PASS SSL: Secure connection to ekoinfolab.pl is available
      PASS SSL: Secure connection to pega.com is available
    
    Interface: lo
      Status:  DOWN
