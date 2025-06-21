import sys, yaml, json

with open('./languages.yaml' ) as f:
    yaml_text = f.read()
    print(json.dumps(yaml.safe_load(yaml_text), ensure_ascii=False))
