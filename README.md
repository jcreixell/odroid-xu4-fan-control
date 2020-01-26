### Adapted for Lakka / LibreELEC

### What does it do?

Allows controlling the fan speed for the Odroid XU4, by setting different fan speeds for different temperature
thresholds.

Out of the box, it sets the fan always on at a low speed, increaing the fan speed as temperature increases. I personally
find this less disturbing as having the fan start and
stop every few seconds. Feel free to change this to whatever is convenient for you.

## Usage

```bash
// Make sure the script is executable
chmod +x odroid-xu4-fan-control.sh

// Run it (as root)
./odroid-xu4-fan-control.sh
```

## Installation

```bash
mkdir /storage/fan-control
cp odroid-xu4-fan-control.sh /storage/fan-control/
cp fan-control.service /storage/.config/system.d/
systemctl daemon-reload

// Start the service
systemctl start fan-control

// Check that it is running
systemctl status fan-control

// Run the script at boot
systemctl enable fan-control
```
