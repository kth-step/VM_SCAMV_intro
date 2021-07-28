#!/usr/bin/env python3

import os
import sys
import subprocess

os.chdir("/home/scamv/scamv/HolBA_logs/EmbExp-Logs/scripts")

dbfile_prefix = "/home/scamv/scamv/orig_exps/"
dbfiles = [
  "table1/1_1_logs_cachepartnopageboundary.db",
  "table1/1_2_logs_cachepartnopageboundary_withenum.db",
  "table1/2_1_logs_cachepartpage_noenum.db",
  "table1/2_2_logs_cachepartpage_withenum.db",
  "table1/3_logs-TemplateA.db",
  # only part1 and part2 are relevant here
  "table1/4_logs-templateB/logs_templateB_batch1_p1p2p3.db",
  "table1/4_logs-templateB/logs_templateB_batch2_p1p2p3.db",

  "figure7/logs-armclaim_mem_address_pc.db",
  "figure7/logs-armclaim_cache_speculation.db",
  "figure7/logs-armclaim_cache_speculation_first.db",
  # templateB part 3, see above
  "figure7/straightline/logs_straightline_b1.db",
  "figure7/straightline/logs_straightline_b2.db"
]

for dbfile in dbfiles:
  dbfile_full = f"{dbfile_prefix}/{dbfile}"

  print(60 * "!")
  print(f"!!!   {dbfile_full}")
  print(60 * "!")

  cmd = ["./db-eval.py", "--dbfile", dbfile_full]
  sys.stdout.flush()
  subprocess.run(cmd)

  print()
  print()


