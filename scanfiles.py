#!/usr/bin/python3
import json
import os
import argparse
import hashlib
from pathlib import Path


_FILE_SCAN_NAME = ".filehash.json"
_DUPLICATE_NAME = ".duplicatefiles.json"
_DEFAULT_SCAN_PATH = str(Path.home())

scan_results_by_file = {}
scan_results_by_md5 = {}
duplicate_files_by_md5 = {}

cur_scan_counter = 0


def get_hash(full_fpath):
    cur_hash = hashlib.md5()
    block_size = 128*cur_hash.block_size
    with open(full_fpath, mode="rb") as file_contents:
        for block in iter(lambda: file_contents.read(block_size), b''):
            cur_hash.update(block)
        return cur_hash.hexdigest()

    return ""


def remove_missing_files():
    for full_fname in scan_results_by_file.keys():
        if not os.path.isfile(full_fname):
            scan_results_by_file.pop(full_fname)


def remove_non_abs_files():
    for full_fname in scan_results_by_file.keys():
        if not os.path.isabs(full_fname):
            scan_results_by_file.pop(full_fname)


def update_md5_map(full_fpath):
    fprops = scan_results_by_file[full_fpath]
    fmd5 = fprops[0]

    try:
        scan_results_by_md5[fmd5].append(full_fpath)
    except:
        scan_results_by_md5[fmd5] = [full_fpath]


def scan_file(full_fpath):
    cached_md5 = None
    new_md5 = None
    cached_props = None
    new_props = [
        os.path.getsize(full_fpath),
        os.path.getmtime(full_fpath)
    ]

    try:
        fprops = scan_results_by_file[full_fpath]
        cached_props = fprops[1:]
        cached_md5 = fprops[0]

    except KeyError:
        pass

    if cached_props != new_props:
        if cached_md5 is not None:
            scan_results_by_md5[cached_md5].remove(full_fpath)
        scan_results_by_file[full_fpath] = [
            get_hash(full_fpath),
            new_props[0],
            new_props[1]
        ]


def load_results(scan_path):
    global scan_results_by_file
    global scan_results_by_md5

    try:
        with open(scan_path, mode="r") as scan_f:
            scan_results_by_file = json.load(scan_f)
    except FileNotFoundError:
        pass
    except json.decoder.JSONDecodeError:
        pass

    remove_missing_files()
    remove_non_abs_files

    for full_fname, fprops in scan_results_by_file.items():
        update_md5_map(full_fname)



def save_results(scan_path):
    global scan_results_by_file

    with open(scan_path, mode="w") as scan_f:
        json.dump(scan_results_by_file, scan_f, indent=4)



def scan_dirs(dirs):
    cur_scan_counter = 0

    for cur_dir in dirs:
        for dirpath, dirnames, fnames in os.walk(cur_dir):
            for fname in fnames:
                fpath = os.path.join(dirpath, fname)
                full_fpath = os.path.abspath(fpath)
                scan_file(full_fpath)
                cur_scan_counter += 1
                print("\rScanned {} files...".format(cur_scan_counter), end="")
    print()


def save_duplicates():
    for k,v in scan_results_by_md5.items():
        if len(v) > 1:
            duplicate_files_by_md5[k] = v


    dup_file_path = os.path.join(args.output_folder, _DUPLICATE_NAME)
    with open(dup_file_path, mode="w") as dup_f:
        json.dump(duplicate_files_by_md5, dup_f, indent=4)


def print_stats():
    print("Number of files duplicated: {}".format(len(duplicate_files_by_md5)))

    total_size_b = 0
    total_size_savings_b = 0
    for k,v in duplicate_files_by_md5.items():
        f_count = len(v)
        f_size = scan_results_by_file[v[0]][1]
        total_size_b += f_count * f_size
        total_size_savings_b += (f_count-1) * f_size

    print("Total Space Savings: {} GiB".format(total_size_savings_b / (1024**3)))



def run_scan(args):
    scan_file_path = os.path.join(args.output_folder, _FILE_SCAN_NAME)
    load_results(scan_file_path)
    remove_missing_files()
    scan_dirs(args.input_directories)
    save_results(scan_file_path)
    save_duplicates()
    print_stats()




if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="File duplication finder")
    parser.add_argument(
        "--in-dirs", "-i",
        nargs="+", 
        required=True,
        dest="input_directories",
        help="Input directories to select"
    )
    parser.add_argument(
        "--output-location", "-o",
        default=_DEFAULT_SCAN_PATH,
        dest="output_folder",
        help="Output file location"
    )
    parser.add_argument(
        "--find-duplicates", "-d",
        dest="find_duplicates",
        action="store_true",
        help="Whether to scan for duplicates"
    )

    args = parser.parse_args()

    run_scan(args)
