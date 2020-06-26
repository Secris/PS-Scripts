$BootTime = (get-date) - (gcim Win32_OperatingSystem).LastBootUpTime

return "Uptime: $($BootTime.Days):$($BootTime.Hours):$($BootTime.Minutes):$($BootTime.Seconds)"
