
$webhookUrl = "WEBHOOK_URL_HERE"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls

function Format-EventInfo {
    param (
        $Event
    )

    $formattedEventInfo = @"
EventID: $($Event.EventID) - A user account was locked out.

Account Name: $($Event.ReplacementStrings[0])

Lockout Source: $($Event.ReplacementStrings[1])

Domain Controller: $($Event.MachineName)

Lockout Timestamp: $($Event.TimeGenerated)

"@
    return $formattedEventInfo
}

function Send-WebhookMessage {
    param (
        $webhookUrl,
        $message
    )

    $payload = @{
        text = $message
    }

    Invoke-WebRequest -Uri $webhookUrl -Method POST -Body (ConvertTo-Json $payload) -ContentType "application/json"
}

$Event = Get-EventLog -LogName Security -InstanceId 4740 | Select-Object -First 1

if ($Event) {
    $formattedEventInfo = Format-EventInfo -Event $Event
    Send-WebhookMessage -webhookUrl $webhookUrl -message $formattedEventInfo
} else {
    Write-Host "Event information is missing."
}
