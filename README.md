# AD Account Lockout Webhook Alert

This repository contains a PowerShell script designed to send webhook notifications upon account lockout events. By monitoring Event ID 4740 in the Windows Security log, this tool provides real-time alerts when user accounts are locked due to failed login attempts.

**License:** GNU General Public License (GPL)

## Features
- **Event-Based Triggers**: Detects account lockout events (Event ID 4740) on domain controllers.
- **Webhook Notifications**: Sends customizable webhook alerts.
- **Enhanced Security Monitoring**: Assists in identifying potential unauthorized access attempts swiftly.

## Requirements
- Windows Server with Task Scheduler.
- Deployment of the script on all Domain Controllers (DCs) for comprehensive lockout monitoring.
- A valid Webhook URL compatible with your alerting platform (e.g., Teams, Slack).

## Setup Instructions

### 1. Download the Script
Clone or download the `AccountLockoutWebhook.ps1` PowerShell script to a folder on each Domain Controller (e.g., `C:\Scripts`).

### 2. Create a Task in Task Scheduler

To trigger the script upon an account lockout event, follow these steps:

#### Open Task Scheduler
1. On each Domain Controller, open Task Scheduler.

#### Create a New Task
1. In the Actions pane, select **Create Task…**.
   
   **General Settings**:
   - **Name**: Enter "Account Lockout Webhook Alert".
   - **Description**: Type "On Event ID 4740, send a webhook notification for account lockouts."
   - **Security Options**: Select **Run with highest privileges**.

2. **Triggers (Event-Based Trigger)**:
   - Go to the **Triggers** tab, then click **New…**.
   - Set **Begin the task** to **On an event**.
   - Configure the event settings:
     - **Log**: Security
     - **Source**: Leave blank
     - **Event ID**: 4740
   - Click **OK** to save the trigger.

3. **Actions (Run the PowerShell Script)**:
   - Go to the **Actions** tab, then click **New…**.
   - Set **Action** to **Start a program**.
   - In **Program/script**, enter the PowerShell path:
     ```
     %windir%\System32\WindowsPowerShell\v1.0\powershell.exe
     ```
   - In **Add arguments (optional)**, enter:
     ```
     -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Scripts\AccountLockoutWebhook.ps1"
     ```
   - Click **OK** to save the action.

4. **Conditions (Power and Network Settings)**:
   - Go to the **Conditions** tab.
   - Uncheck **Start the task only if the computer is on AC power**.

5. **Settings**:
   - Go to the **Settings** tab and adjust the following options:
     - Check **Allow task to be run on demand**.
     - Set **If the task is already running** to **Do not start a new instance**.

6. **Save the Task**:
   - Click **OK** to save the task.

### 3. Test the Setup
- Lock a test account to ensure the script triggers and a webhook notification is sent successfully.

## License
This project is licensed under the GNU General Public License (GPL). See the LICENSE file for details.
"""

## Usage Notes
- **DC Deployment**: Ensure this task is configured on all Domain Controllers to capture all account lockout events across the domain.
- **Webhook URL**: Update the webhook URL in the script to integrate with your alerting platform (e.g., Teams, Slack).

