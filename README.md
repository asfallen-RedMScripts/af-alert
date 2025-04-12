# Alert System for RedM [RSG-CORE]

The Alert System is a comprehensive notification system designed for RedM, enabling dynamic alert creation when certain events occur, such as gunshots or custom events. It allows server administrators to configure alerts that trigger when specific criteria are met, and send real-time notifications to players in the vicinity.

## Features

- **Gunshot Alerts**: Automatically trigger alerts when shots are fired within a certain radius.
- **Custom Alerts**: Create custom alerts with configurable messages, distances, and targeted job roles.
- **Blips for Alerts**: Display map blips for both gunfire and custom alerts with configurable appearance settings.
- **Cooldowns**: Prevent repeated alerts in a short period by setting cooldown times between shots.
- **Job-based Alerts**: Control which player jobs receive alerts, such as police, sheriff, and others.
- **Debug Mode**: An optional debug mode to log additional information about alert generation and event triggering.

## Custom Alerts

You can create your own custom alerts with unique messages, blip types, and target job roles. To do this, you need to define the blips in the `config.lua` file and then trigger the alerts using the `CallSendCustomAlert` function.

### Adding Custom Blips

To add a custom blip type, define it in the `Config.Blips` table in the `config.lua` file. For example:

```lua
Config.Blips = {
    -- Existing blip types...
    robbery = {
        sprite = 123456,  -- Change with actual sprite ID
        scale = 0.5,
        label = "Robbery Alert",
        modifier = `blip_robbery`,
        color = 1,
        areaSize = 10.0
    },
    emergency = {
        sprite = 654321,  -- Change with actual sprite ID
        scale = 0.5,
        label = "Emergency",
        modifier = `blip_emergency`,
        color = 1,
        areaSize = 10.0
    }
}
```


## Requirements

- **RSG-Core**
- **ox_lib**


## Test Video
 

https://github.com/user-attachments/assets/3132ec81-e9e0-4125-bd53-a88610262cb9


## Installation

1. **Clone the repository** into your RedM resources folder.

   ```bash
   git clone https://github.com/your-repo/af-alert.git
