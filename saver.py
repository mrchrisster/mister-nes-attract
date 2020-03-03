import zipfile
import os
import random

archive_name = "pix.zip"
zipfile = zipfile.ZipFile(archive_name, 'r')
random_zip_member = random.choice(zipfile.namelist())
zipfile.extract(random_zip_member)
print("Extracted", random_zip_member)

