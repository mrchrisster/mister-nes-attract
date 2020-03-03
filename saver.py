import zipfile
import os
import random

def extract_random(folder, start_pattern):
    for rom_archive in os.listdir(folder):
        if rom_archive.startswith(start_pattern):
            zip = zipfile.ZipFile(rom_archive, 'r')
            # only .sfc
            random_zip_member = random.choice(zip.namelist())
            zip.extract(random_zip_member)
            print("Extracted", random_zip_member)


extract_random(".", "pix")
