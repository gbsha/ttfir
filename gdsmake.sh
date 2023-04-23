#!/bin/bash
../../TinyTapeout/tt-support-tools/tt_tool.py --create-user-config
OPENLANE_IMAGE_NAME="efabless/openlane:cb59d1f84deb5cedbb5b0a3e3f3b4129a967c988-amd64" ../../TinyTapeout/tt-support-tools/tt_tool.py --harden
