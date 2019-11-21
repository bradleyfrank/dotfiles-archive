#!/usr/bin/env python3

__author__ = 'Bradley Frank'

import argparse
import json
import logging
import os
import shutil
import subprocess
import sys
import urllib.request
from urllib.error import HTTPError
from urllib.error import URLError

PROJECTS = {
    'VSCodium': ['VSCodium', 'vscodium'],
}
DOWNLOAD_DIR = '/usr/local/cache/yum2'
GITHUB_URL = 'https://api.github.com/repos/'

def get_latest_release(name, owner, repo, repolog):
    # Create URL
    release_url = GITHUB_URL + owner + '/' + repo + '/releases/latest'

    # Download release feed from GitHub
    try:
        response = urllib.request.urlopen(release_url)
    except HTTPError as e:
        print(name + ': could not download release information.')
        repolog.log('error', e.code)
        return False
    except URLError as e:
        print(name + ': could not download release information.')
        repolog.log('error', e.reason)
        return False

    data = response.readline().decode('utf-8')
    feed = json.loads(data)

    # Check that feed actually has releases
    if 'assets' not in feed:
        print(name + ': could not find release information.')
        return False
    else:
        repolog.log('info', name + ': downloaded release information.')

    # Search releases for RPM file
    for asset in feed['assets']:
        if asset['name'].endswith('.rpm'):
            download_url = asset['browser_download_url']
            rpm_name = asset['name']
            repolog.log('info', name + ': found latest release RPM.')
            break
    else:
        print('RPM file not found.')
        return False

    # Append new version filename to repo directory
    filename = os.path.join(DOWNLOAD_DIR, rpm_name)

    # Skip if file already exists
    if os.path.isfile(filename):
        print(name + ': RPM is already at latest release.')
        return False

    # Download the actual RPM file
    try:
        response = urllib.request.urlopen(download_url)
    except HTTPError as e:
        print('Could not download release.')
        repolog.log('error', e.code)
        return False
    except URLError as e:
        print('Could not download release.')
        repolog.log('error', e.reason)
        return False

    # Save the RPM file to disk
    try:
        with open(filename, 'wb') as f:
            shutil.copyfileobj(response, f)
    except IOError as e:
        print(name + ': could not save ' + rpm_name + '.')
        repolog.log('error', e)
        return False

    print(name + ': updated to latest release.')
    return True

def createrepo(repolog):
    try:
        subprocess.call(['createrepo', DOWNLOAD_DIR],
                        stdout=open(os.devnull, 'wb'),
                        stderr=open(os.devnull, 'wb'))
    except OSError as e:
        print('Error creating repository.')
        repolog.log('error', e)
        return False

    print('Successfully created repository.')
    return True

class myLogger:

    def __init__(self, debug=False):
        # Logging settings
        self.logger = logging.getLogger('reposyncer')
        if not debug:
            log_level = 0
        else:
            log_level = 10
        self.logger.setLevel(log_level)

        # Logging formats
        _log_format = '[%(asctime)s] [%(levelname)8s] %(message)s'
        log_format = logging.Formatter(_log_format, '%H:%M:%S')

        # Adds a console handler to the logger
        ch = logging.StreamHandler(sys.stdout)
        ch.setLevel(log_level)
        ch.setFormatter(log_format)
        self.logger.addHandler(ch)

    def log(self, lvl, msg):
        level = logging.getLevelName(lvl.upper())
        self.logger.log(level, msg)

# Set available arguments
parser = argparse.ArgumentParser(
    description='Wrapper for reposync and createrepo.')
parser.add_argument('-d', '--debug', action='store_true',
                    help='enables debug messages')
args = parser.parse_args()

# Configure debugging
if args.debug:
    repolog = myLogger(True)
else:
    repolog = myLogger(False)

# Create repo directory if it doesn't exist
if not os.path.isdir(DOWNLOAD_DIR):
    os.makedirs(DOWNLOAD_DIR, exist_ok=True)

# Update each RPM
for name, repo in PROJECTS.items():
    get_latest_release(name, repo[0], repo[1], repolog)

# Re-create the repository
createrepo(repolog)
