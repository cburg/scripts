#!/usr/bin/python3
"""
Simple utility to find duplicate files in a given set of directories. There are 
two modes 'full' and 'fast (not full)'. 

In the 'fast' mode, files are first compared by name and size, if a file with 
the same name and size has already been identified, then a hash of both files is
used to identify whether they are duplicates. This is the recommended mode for
finding duplicates where files have been simply copied and moved.

In the 'full' mode, files are compared only by their hashes. Any two or more 
files with the same hash are marked as duplicates. This will thus identify 
duplicates even if they have been renamed.

This utility was written with the goal in mind of dealing with duplicate 
pictures coming from phone and camera backups / syncs and the frequent use of 
'to be sorted' folders :P.
"""
import os
import hashlib
import argparse
import time

duplicates = {} # {<hash>: [<duplicate1>, <duplicate2>]}
all_files = {}
files_processed = 0

_RESULTS_LEVELS = {
    "h": "Folder Hits",
    "s": "Summary",
    "l": "Duplicates List"
}

_RESULTS_HELP_LIST = ", ".join(
    [k + "=" + _RESULTS_LEVELS[k] for k in sorted(_RESULTS_LEVELS.keys())]
)

_DEFAULT_RESULTS_LEVEL = "l"

starttime = 0
endtime = 0

def get_hash(entry_path):
    with open(entry_path, mode="rb") as file_contents:
        cur_hash = hashlib.md5(file_contents.read()).hexdigest()
        return cur_hash

    return ""


def add_duplicate(cur_hash, existing_path, current_path):
    try:
        cur_file_list = duplicates[cur_hash]
        cur_file_list.add(current_path)
    except Exception:
        duplicates[cur_hash] = set([existing_path, current_path])
    

def add_entry(entry, current_entry_path, full, contents_only=False):
    cur_id = None
    cur_hash = None

    # Get ID to lookup
    if full:
        cur_hash = get_hash(current_entry_path)
        if contents_only:
            cur_id = cur_hash
        else:
            cur_id = cur_hash + "_" + entry

    else:
        cur_size = os.path.getsize(current_entry_path)
        cur_id = str(cur_size) + "_" + entry

    # Check if entry exists
    try:
        # If entry exists, check if we're a duplicate
        existing_file_entries = all_files[cur_id]

        # Make sure we have a hash for the current file
        if not full:
            cur_hash = get_hash(current_entry_path)

        # Check against all 
        for existing_file_entry in existing_file_entries:
            existing_file_path = existing_file_entry[0]
            existing_file_hash = existing_file_entry[1]

            if existing_file_hash is None:
                existing_file_hash = get_hash(existing_file_path)
                existing_file_entry[1] = existing_file_hash

            if existing_file_hash == cur_hash:
                add_duplicate(cur_hash, existing_file_path, current_entry_path)

        # If we're in fast mode, add our current file to the list
        if not full:
            existing_file_entries.append([current_entry_path, cur_hash])

    # Or add it as an entry it if not
    except Exception:
        all_files[cur_id] = [[current_entry_path, cur_hash]]


def dedup_folder(cur_dir, full=False, verbose=False):
    global files_processed
    cur_entries = sorted(os.listdir(cur_dir))
    for entry in cur_entries:
        cur_entry_path = cur_dir + os.sep + entry
        if os.path.isdir(cur_entry_path):
            dedup_folder(cur_entry_path, full, verbose)
        else:
            files_processed += 1
            if verbose:
                print("PROCESSING {}: {}".format(files_processed, cur_entry_path))

            add_entry(entry, cur_entry_path, full)


def dedup(args):
    global starttime
    global endtime

    starttime = time.time()

    for folder in args.input_directories:
        dedup_folder(folder, args.full, args.verbose)

    endtime = time.time()

def dump_summary():
    print("Total Files Processed: {}".format(files_processed))
    print("Total Duplicated Files: {}".format(len(duplicates)))

    elapsed_time = time.gmtime(endtime - starttime)
    print("Time Elapsed: {}".format(time.strftime("%H:%M:%S", elapsed_time)))


def dump_folder_hits():

    folders = {}
    for k in duplicates.keys():
        for i in duplicates[k]:
            cur_folder = os.path.dirname(i)
            try:
                folders[cur_folder] += 1
            except Exception:
                folders[cur_folder] = 1

    # Create a list of tuples so we can easily sort
    folders = [(k, folders[k]) for k in folders.keys()]

    for f in sorted(folders, key=lambda x: x[1], reverse=True):
        out_str = "{}\n\t{}".format(f[0], f[1])
        print(out_str)


def dump_file_list():

    for k in duplicates.keys():
        out_str = k + "\n\t" + "\n\t".join(duplicates[k])
        print(out_str)


def dump_result(result_type="", cb=None):
    print("BEGIN {}\n".format(result_type))

    if cb is not None:
        cb()

    print("\nEND {}\n".format(result_type))
    print()


def dump_results(args):

    results = args.results

    if "s" in results or "summary" in results:
        # Dump Summary
        dump_result("SUMMARY", dump_summary)

    if "h" in results or "folderhits" in results:
        # Dump Folder Hits
        dump_result("FOLDER_HITS", dump_folder_hits)

    if "l" in results or "":
        # Dump Files
        dump_result("DUPLICATE_LIST", dump_file_list)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="File duplication finder")
    parser.add_argument(
        "--full", "-f", 
        dest="full", 
        action="store_true",
        help="Performs a full comparison of each file. This will mark every file with the same hash as a duplicate. If not specified, then only files with the same name and size will be compared via hash."
    )
    parser.add_argument(
        "--in-dirs", "-i", 
        nargs="+", 
        required=True,
        dest="input_directories",
        help="Input directories to select"
    )
    parser.add_argument(
        "--verbose", "-v", 
        action="store_true", 
        dest="verbose",
        help="Prints every file name that has been processed along with the total number of files that have been processed up until that point."
    )
    parser.add_argument(
        "--results", "-r",
        nargs="*",
        default=[_DEFAULT_RESULTS_LEVEL],
        dest="results",
        help="Results Levels are: {}".format(_RESULTS_HELP_LIST)
    )

    args = parser.parse_args()

    dedup(args)
    dump_results(args)
