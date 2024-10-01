[Russian README](./README_RUS.md)
# NetWatch

NetWatch is a simple bash script that monitors network connectivity to specified hosts and executes scripts when connections are lost.

## Table of Contents

- [Usage](#usage)
- [Examples](#examples)
- [Configuration](#configuration)

## Usage
```netwatch.sh HOST SCRIPT```

Where:
- `HOST`: IP address or hostname to monitor
- `SCRIPT`: Command or script to execute when host becomes unavailable

## Examples
``` bash
netwatch.sh 1.1.1.1 /usr/local/bin/my_script 
netwatch.sh 8.8.8.8 reboot 
netwatch.sh 1.1.1.1 "echo hello world"
```
## Configuration
Make the script executable:
```bash
chmod +x netwatch.sh
```
You can change the time between checks by changing the variable DELAY in the script.

The script checks for the existence of the specified command or script. It also validates that the host is a valid IP address.

## How it works

1. The script pings the specified host every 10 seconds.
2. If the host becomes unavailable (3 consecutive failed pings), it executes the specified script.
3. When the host becomes available again, it resets the counters and status.
