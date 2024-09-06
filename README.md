# NetHunter Fixing Script

A simple script to resolve common issues in Kali NetHunter, such as internet connectivity problems, apt update errors, source list configuration, and VNC/Kex server issues.

## Description

This script addresses popular issues in NetHunter, ensuring smoother operation by fixing problems like "no internet connection," inability to perform `apt update`, restoring default apt sources, and resolving VNC/Kex server errors.

## Dependencies

- An active internet connection is required for installing essential tools on the NetHunter distribution.

## Installation & Execution

1. Navigate to the script directory:
   ```bash
   cd /Nethunter_fixes
   ```

2. Make the script executable:
   ```bash
   chmod +x *
   ```

3. Run the script:
   ```bash
   ./nethunter_fixes.sh
   ```

4. That's it! Enjoy your fixed NetHunter experience. 😊

## Help

The script provides various options to address different issues:

1. **Fix Internet Connection:**
   - Resolves issues with internet connectivity during `apt update`, `apt dist-upgrade`, or pinging (e.g., `ping 8.8.8.8`) by editing configuration files in the `/etc` directory.

2. **Fix Apt Key:**
   - Updates and replaces apt keys to resolve `apt update` errors.

3. **Fix Sources:**
   - Restores default sources from the Kali NetHunter website and updates the `/etc/apt/sources.list` file.

4. **Fix VNC & Kex:**
   - Repairs errors related to VNC or Kex servers to ensure smooth operation.

5. **Install NetHunter Main Tools:**
   - Installs essential tools for daily use and runs main scripts or tools. If you wish to add a new tool, please add it to the `tools.txt` file.

0. **About & Help:**
   - Displays the main help menu in the terminal.

## Authors

- **Developer:** Ahmad Allam
  - Telegram: [@echo_Allam](https://t.me/echo_Allam)
  - Remember Palestine ❤️