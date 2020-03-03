import zipfile
import os
import random

def extract_random(folder, start_pattern):
    for rom_archive in os.listdir(folder):
        if rom_archive.startswith(start_pattern):
            zip = zipfile.ZipFile(os.path.join(folder, rom_archive), 'r')
            
            # filtering: list comprehension
            only_sfc = [f for f in zip.namelist() if f.endswith("sfc")]
            
            # uncomment next for only .sfc
            # random_zip_member = random.choice(only_sfc)
            random_zip_member = random.choice(zip.namelist())
            zip.extract(random_zip_member, "boot.rom")
            print "Extracted", random_zip_member, "to boot.rom"


extract_random(".", "pix")
