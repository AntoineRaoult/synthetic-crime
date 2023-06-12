from sys import argv
from subprocess import call
import os

def run_R_script(start: int, end: int, m: int):
    current_start: int = start
    current_end: int = start + m - 1

    while current_end <= end:
        call(["Rscript", "Part2-modified.R"] + [str(current_start), str(current_end)])
        #os.system(f"curl -X POST http://130.61.29.67:8000/upload -F \"files=@../script2-data/synthetic_population{current_start}_{current_end}.RData\" -u @dm1n:liuytrdcvbnkloiuytrfdcvbnjkiuygtf")
        print(f"Data sended for the arguments {current_start}, {current_end}")
        current_start = current_end + 1
        current_end = current_end + m 
    
    if current_end > end and current_start < end:
        call(["Rscript", "Part2-modified.R"] + [str(current_start), str(end)])
        #os.system(f"curl -X POST http://130.61.29.67:8000/upload -F \"files=@../script2-data/synthetic_population{current_start}_{current_end}.RData\" -u @dm1n:liuytrdcvbnkloiuytrfdcvbnjkiuygtf")


if __name__ == "__main__":
    start: int = int(argv[1])
    end: int = int(argv[2])
    m: int = int(argv[3]) # 200
    try:
        run_R_script(start, end, m)
    finally:
        print(f"Data sended for the run_R_script({start}, {end}, {m})")
