#!/usr/bin/env python3

from datetime import datetime
import time
import json

LOG_TIME = datetime.today()

LOG_FILE_NAME = f'{LOG_TIME.strftime("%Y-%m-%d")}-awesome-monitoring.log'

LOG_FILE_PATH = f'/var/log/{LOG_FILE_NAME}'

CPU_METRIC = '/proc/stat'

CPU_KEYS = ['user',    'nice',   'system',  'idle',      'iowait',
            'irq',   'softirq',  'steal',  'guest',  'guest_nice']

CPU_TIME_WAIT = 1

MEM_METRIC = '/proc/meminfo'


def _read_metrics(path):
    with open(path, 'r') as file:
        data = file.read().rstrip()
    return data


def _parse_cpu_metrics(data):
    metric_data = {}

    for metric_line in data.splitlines():
        if metric_line.find('cpu') == 0:
            metric_line_values = metric_line.split()
            metric_line_data = {}

            for idx, value in enumerate(metric_line_values[1:]):
                metric_line_data[CPU_KEYS[idx]] = int(value)

            metric_data[metric_line_values[0]] = metric_line_data

    return metric_data


def _calc_cpu_usage(current_cpu_metric, prev_cpu_metric):
    prev_idle = prev_cpu_metric['idle'] + prev_cpu_metric['iowait']
    idle = current_cpu_metric['idle'] + current_cpu_metric['iowait']

    prev_non_idle = prev_cpu_metric['user'] + prev_cpu_metric['nice'] + prev_cpu_metric['system'] + \
        prev_cpu_metric['irq'] + prev_cpu_metric['softirq'] + \
        prev_cpu_metric['steal']

    non_idle = current_cpu_metric['user'] + current_cpu_metric['nice'] + current_cpu_metric['system'] + \
        current_cpu_metric['irq'] + current_cpu_metric['softirq'] + \
        current_cpu_metric['steal']

    prev_total = prev_idle + prev_non_idle
    total = idle + non_idle

    # differentiate: actual value minus the previous one
    totald = total - prev_total
    idled = idle - prev_idle

    return round((totald - idled)/totald, 2)


def _create_cpu_usage_metrics(current_cpu_metrics, prev_cpu_metrics):
    cpu_usage_metric = {}
    for key in current_cpu_metrics.keys():
        cpu_usage_metric[key] = _calc_cpu_usage(
            current_cpu_metrics[key], prev_cpu_metrics[key])

    return cpu_usage_metric


def _parse_mem_metrics(data):
    metric_data = {}

    for metric_line in data.splitlines():
        if metric_line.find('MemTotal') == 0:
            metric_line_values = metric_line.split()
            metric_data['mem_total'] = int(metric_line_values[1])
        if metric_line.find('MemFree') == 0:
            metric_line_values = metric_line.split()
            metric_data['mem_free'] = int(metric_line_values[1])
        if metric_line.find('MemAvailable') == 0:
            metric_line_values = metric_line.split()
            metric_data['mem_available'] = int(metric_line_values[1])

    return metric_data


def _write_metrics(path, data):
    # json.dump(data, open(path, 'a'))
    with open(path, 'a') as file:
        file.write(str(data) + '\n')
    # return

def main():

    prev_cpu_metrics = _parse_cpu_metrics(_read_metrics(CPU_METRIC))

    # Need to get some sleep to compare the current values with the previous ones
    time.sleep(CPU_TIME_WAIT)

    current_cpu_metrics = _parse_cpu_metrics(_read_metrics(CPU_METRIC))

    current_cpu_usage_metrics = _create_cpu_usage_metrics(
        current_cpu_metrics, prev_cpu_metrics)

    current_mem_metrics = _parse_mem_metrics(_read_metrics(MEM_METRIC))

    _write_metrics(LOG_FILE_PATH, {**{'timestamp': LOG_TIME.timestamp()},
                **current_cpu_usage_metrics, **current_mem_metrics})

if __name__ == "__main__":
    main()