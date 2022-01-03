#!/usr/bin/env python
import pathlib
import statistics
import subprocess
import time

# paired with fan speed (0-255) and temp (degrees C)
f_low_speed = 0
f_low_temp = 45

f_mid_temp = 50

f_high_speed = 254
f_high_temp = 95

old_f_speed = f_speed = 254

sys_platform = pathlib.Path('/sys/devices/platform')
temperature_files = list(sys_platform.rglob('coretemp.*/hwmon/hwmon*/temp*_input'))

while True:
    temp_lst = [
        int(file.read_text()) // 1000
        for file in temperature_files
    ]

    avg_temp = statistics.mean(temp_lst)

    # find what speed the fan should be
    if avg_temp < f_low_temp:
        f_speed = f_low_speed
    elif avg_temp > f_high_temp:
        f_speed = f_high_speed
    else:
        if avg_temp < f_mid_temp:
            f_speed = f_low_speed
        else:
            f_speed_f = f_low_speed + ((avg_temp - f_low_temp) / (f_high_temp - f_low_temp) * (f_high_speed - f_low_speed))
            f_speed = int(f_speed_f)

    print(f'Temperature: {avg_temp}°C, Fan speed: 0x{f_speed:02x}')

    if old_f_speed != f_speed:
        subprocess.check_output(['ipmitool', 'raw', '0x3a', '0x07', '0x1', hex(f_speed), '0x01'])
        subprocess.check_output(['ipmitool', 'raw', '0x3a', '0x07', '0x2', hex(f_speed), '0x01'])
        subprocess.check_output(['ipmitool', 'raw', '0x3a', '0x07', '0x3', hex(f_speed), '0x01'])
        old_f_speed = f_speed
    time.sleep(5)
