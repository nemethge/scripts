import json
from urllib.request import urlopen, Request


def main():
    url = 'https://api.github.com/users/nemethge/repos'
    req = Request(url, headers={'Accept': 'application/vnd.github.v3+json'})
    with urlopen(req) as resp:
        data = json.load(resp)

    for repo in data:
        print(repo.get('name'))


if __name__ == '__main__':
    main()
