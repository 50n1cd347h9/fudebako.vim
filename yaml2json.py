import sys, yaml, json


def main():
    if len(sys.argv) != 2:
        return
    yaml_path = sys.argv[1]
    with open(yaml_path) as f:
        yaml_text = f.read()
        print(json.dumps(yaml.safe_load(yaml_text), ensure_ascii=False))


if __name__ == "__main__":
    main()
