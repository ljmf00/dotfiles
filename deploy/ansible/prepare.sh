#!/usr/bin/env bash

(cd ../docker && make dist)
ansible-galaxy collection install -r requirements.yml
