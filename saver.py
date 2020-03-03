import zipfile
import os
import random

archive_name = "pix.zip"
zipfile = zipfile.ZipFile(archive_name, 'r')
SNESrandomrom = random.choice(zipfile.namelist())
print(SNESrandomrom)

