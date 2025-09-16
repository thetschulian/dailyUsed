#!/bin/bash

echo "🔧 Attempting to disable Intel Turbo Boost..."

# Check if intel_pstate interface exists
if [ -f /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
  echo "✅ intel_pstate detected"
  echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
  echo "Turbo Boost disabled via intel_pstate"
elif [ -f /sys/devices/system/cpu/cpufreq/boost ]; then
  echo "✅ cpufreq interface detected"
  echo 0 | sudo tee /sys/devices/system/cpu/cpufreq/boost
  echo "Turbo Boost disabled via cpufreq"
else
  echo "❌ No known Turbo Boost control interface found"
  echo "This system may be virtualized or lack CPU scaling support"
fi

echo "✅ Done."

nano /etc/systemd/system/disable-turbo.service
###### Content Start 

[Unit]
Description=Disable Intel Turbo Boost
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

###### Content END 

sudo systemctl daemon-reexec
sudo systemctl enable disable-turbo.service
