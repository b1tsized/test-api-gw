import gzip
import json
import base64
import requests


def lambda_handler(event, context):
    print(f'Logging Event: {event}')
    print(f"Awslog: {event['awslogs']}")
    cw_data = event['awslogs']['data']
    print(f'data: {cw_data}')
    print(f'type: {type(cw_data)}')
    compressed_payload = base64.b64decode(cw_data)
    uncompressed_payload = gzip.decompress(compressed_payload)
    payload = json.loads(uncompressed_payload)
    log_events = payload['logEvents']
    for log_event in log_events:
        url = 'http://18.223.172.41:8080'
        myobj = {'LogEvent': payload}
        x = requests.post(url, json = myobj)
        print(f'LogEvent: {payload}')
        print(x.text)