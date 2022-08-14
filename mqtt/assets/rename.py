import os
import glob
import shutil
import sys
import re


def rename_icons():
    for file in glob.glob(os.path.join(os.path.dirname(__file__), 'icons', '*/*.png')):
        if os.path.isfile(file):
            # replace 2x and 3x with @2x and @3x with ''
            new_name = re.sub(r'@2x|@3x', '', os.path.basename(file))
            new_name = new_name.lower()
            # rename
            os.rename(file, os.path.join(os.path.dirname(file), new_name))


if __name__ == '__main__':
    rename_icons()
