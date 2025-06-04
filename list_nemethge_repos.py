"""List all public repositories for GitHub user ``nemethge``.

The script uses the GitHub REST API and supports pagination to ensure all
repositories are retrieved. If the environment variable ``GITHUB_TOKEN`` is
set, it will be used for authentication which increases the API rate limit.
"""

import os
import requests


def main():
    user = 'nemethge'
    url = f'https://api.github.com/users/{user}/repos'
    headers = {'Accept': 'application/vnd.github.v3+json'}
    token = os.getenv('GITHUB_TOKEN')
    if token:
        headers['Authorization'] = f'token {token}'

    params = {'per_page': 100, 'page': 1}
    repos = []
    while True:
        resp = requests.get(url, headers=headers, params=params, timeout=10)
        resp.raise_for_status()
        data = resp.json()
        if not data:
            break
        repos.extend(r.get('name') for r in data)
        params['page'] += 1

    for name in repos:
        print(name)


if __name__ == '__main__':
    main()
