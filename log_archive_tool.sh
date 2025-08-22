#!/usr/bin/env python3
import os
import sys
import tarfile
from datetime import datetime
from pathlib import Path

def main():
    #Parse arguments
    if len(sys.argv) != 2:
        print("Usage: log-archive <log-directory>")
        sys.exit(1)
    log_dir = Path(sys.argv[1])
    
    if not log_dir.exists() or not log_dir.is_dir():
        print(f"Error: {log_dir} does not exist or is not a directory.")
        sys.exit(1)

    #Prepare output directory
    archive_dir = Path.home() / "archived_logs"
    archive_dir.mkdir(exist_ok=True)

    #Generate archive filename
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    archive_name = f"logs_archive_{timestamp}.tar.gz"
    archive_path = archive_dir / archive_name

    #Compress logs
    with tarfile.open(archive_path, "w:gz") as tar:
        tar.add(log_dir, arcname=os.path.basename(log_dir))

    #Log history
    history_file = archive_dir / "archive_history.log"
    with open(history_file, "a") as f:
        f.write(f"{datetime.now()} - Archived {log_dir} -> {archive_path}\n")

    print(f"Logs archived: {archive_path}")
    print(f"Log entry saved in: {history_file}")

if __name__ == "__main__":
    main()
