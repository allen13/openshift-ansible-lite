Infernalis release benchmark:

Benchmark configuration
=======================

Using Infernalis release
```
ceph --version
ceph version 9.2.1 (752b6a3020c3de74e07d2a8b4c5e48dab5a6b6fd)
```

fio config (all.fio)
```
[global]
iodepth=32
runtime=30
ioengine=libaio
direct=1
filename=${DEVICE}
ramp_time=2

[seq-read-64k]
rw=read
bs=64k
iodepth_batch_submit=8
iodepth_batch_complete=8

[seq-write-64k]
rw=write
bs=64k
iodepth_batch_submit=8
iodepth_batch_complete=8

[rand-write-64k]
rw=randwrite
bs=64k
iodepth_batch_submit=1
iodepth_batch_complete=1

[rand-read-64k]
rw=randread
bs=64k
iodepth_batch_submit=1
iodepth_batch_complete=1

[rand-write-4k]
rw=randwrite
bs=4k
iodepth_batch_complete=1
iodepth_batch_submit=1

[rand-read-4k]
rw=randread
bs=4k
iodepth_batch_submit=1
iodepth_batch_complete=1

[seq-read-4k]
rw=read
bs=4k
iodepth_batch_submit=8
iodepth_batch_complete=8

[seq-write-4k]
rw=write
bs=4k
iodepth_batch_submit=8
iodepth_batch_complete=8
```

Benchmark script (ceph-benchmark.sh)
```
#!/bin/bash

rbd create --size=102400 bench
export DEVICE=$(rbd map bench)

fio --output=seq-write-64k --section=seq-write-64k all.fio
fio --output=rand-write-64k --section=rand-write-64k all.fio
fio --output=seq-write-4k --section=seq-write-4k all.fio
fio --output=rand-write-4k --section=rand-write-4k all.fio
fio --output=seq-read-64k --section=seq-read-64k all.fio
fio --output=rand-read-64k --section=rand-read-64k all.fio
fio --output=seq-read-4k --section=seq-read-4k all.fio
fio --output=rand-read-4k --section=rand-read-4k all.fio

rbd unmap bench
rbd rm bench
```


Across 4 servers with 3 SSD OSDs each (replication 3)
=====================================================

```
rand-read-4k: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=24
rand-read-4k: (groupid=0, jobs=1): err= 0: pid=1209009: Fri May 13 16:35:02 2016
  read : io=6053.5MB, bw=206616KB/s, iops=51653, runt= 30001msec
    slat (usec): min=1, max=126, avg= 4.18, stdev= 2.39
    clat (usec): min=169, max=29597, avg=458.92, stdev=196.83
     lat (usec): min=175, max=29603, avg=463.23, stdev=196.75
    clat percentiles (usec):
     |  1.00th=[  270],  5.00th=[  302], 10.00th=[  322], 20.00th=[  354],
     | 30.00th=[  378], 40.00th=[  406], 50.00th=[  434], 60.00th=[  466],
     | 70.00th=[  498], 80.00th=[  548], 90.00th=[  620], 95.00th=[  692],
     | 99.00th=[  868], 99.50th=[  964], 99.90th=[ 1288], 99.95th=[ 1768],
     | 99.99th=[ 6112]
    bw (KB  /s): min=    2, max=210304, per=98.35%, avg=203200.03, stdev=26972.63
    lat (usec) : 250=0.28%, 500=69.77%, 750=26.99%, 1000=2.58%
    lat (msec) : 2=0.33%, 4=0.03%, 10=0.01%, 20=0.01%, 50=0.01%
  cpu          : usr=13.98%, sys=34.78%, ctx=840339, majf=0, minf=7697
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=106.6%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=1549652/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=24

Run status group 0 (all jobs):
   READ: io=6053.5MB, aggrb=206616KB/s, minb=206616KB/s, maxb=206616KB/s, mint=30001msec, maxt=30001msec

Disk stats (read/write):
  rbd0: ios=1646984/0, merge=0/0, ticks=747425/0, in_queue=767906, util=100.00%
```

---

```
rand-read-64k: (g=0): rw=randread, bs=64K-64K/64K-64K/64K-64K, ioengine=libaio, iodepth=24
rand-read-64k: (groupid=0, jobs=1): err= 0: pid=1207651: Fri May 13 16:32:51 2016
  read : io=68632MB, bw=2287.7MB/s, iops=36601, runt= 30001msec
    slat (usec): min=3, max=109, avg= 7.34, stdev= 2.83
    clat (usec): min=182, max=37195, avg=646.74, stdev=335.21
     lat (usec): min=190, max=37202, avg=654.23, stdev=335.17
    clat percentiles (usec):
     |  1.00th=[  330],  5.00th=[  378], 10.00th=[  410], 20.00th=[  470],
     | 30.00th=[  516], 40.00th=[  564], 50.00th=[  604], 60.00th=[  644],
     | 70.00th=[  700], 80.00th=[  780], 90.00th=[  908], 95.00th=[ 1048],
     | 99.00th=[ 1480], 99.50th=[ 1704], 99.90th=[ 2480], 99.95th=[ 3312],
     | 99.99th=[ 9280]
    bw (MB  /s): min=    0, max= 2387, per=98.26%, avg=2247.94, stdev=305.22
    lat (usec) : 250=0.03%, 500=25.90%, 750=51.00%, 1000=16.76%
    lat (msec) : 2=6.08%, 4=0.19%, 10=0.03%, 20=0.01%, 50=0.01%
  cpu          : usr=10.31%, sys=38.25%, ctx=633921, majf=0, minf=4000
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=106.6%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=1098082/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=24

Run status group 0 (all jobs):
   READ: io=68632MB, aggrb=2287.7MB/s, minb=2287.7MB/s, maxb=2287.7MB/s, mint=30001msec, maxt=30001msec

Disk stats (read/write):
  rbd0: ios=1167057/0, merge=0/0, ticks=747637/0, in_queue=768332, util=100.00%
```

---

```
rand-write-4k: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=24
rand-write-4k: (groupid=0, jobs=1): err= 0: pid=1208341: Fri May 13 16:33:56 2016
  write: io=1476.9MB, bw=50403KB/s, iops=12599, runt= 30003msec
    slat (usec): min=1, max=113, avg= 6.44, stdev= 2.91
    clat (usec): min=928, max=30147, avg=1895.73, stdev=732.38
     lat (usec): min=933, max=30153, avg=1902.38, stdev=732.32
    clat percentiles (usec):
     |  1.00th=[ 1160],  5.00th=[ 1288], 10.00th=[ 1368], 20.00th=[ 1480],
     | 30.00th=[ 1576], 40.00th=[ 1672], 50.00th=[ 1768], 60.00th=[ 1880],
     | 70.00th=[ 2008], 80.00th=[ 2160], 90.00th=[ 2480], 95.00th=[ 2832],
     | 99.00th=[ 4128], 99.50th=[ 5152], 99.90th=[10560], 99.95th=[14016],
     | 99.99th=[19328]
    bw (KB  /s): min=    2, max=53776, per=98.45%, avg=49618.55, stdev=7024.18
    lat (usec) : 1000=0.02%
    lat (msec) : 2=69.84%, 4=29.03%, 10=1.01%, 20=0.10%, 50=0.01%
  cpu          : usr=5.46%, sys=12.68%, ctx=312148, majf=0, minf=5124
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=107.1%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=378037/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=24

Run status group 0 (all jobs):
  WRITE: io=1476.9MB, aggrb=50402KB/s, minb=50402KB/s, maxb=50402KB/s, mint=30003msec, maxt=30003msec

Disk stats (read/write):
  rbd0: ios=60/403898, merge=0/0, ticks=17/760620, in_queue=768108, util=99.98%
```

---

```
rand-write-64k: (g=0): rw=randwrite, bs=64K-64K/64K-64K/64K-64K, ioengine=libaio, iodepth=24
rand-write-64k: (groupid=0, jobs=1): err= 0: pid=1206927: Fri May 13 16:31:46 2016
  write: io=13188MB, bw=450105KB/s, iops=7032, runt= 30003msec
    slat (usec): min=4, max=224, avg=10.47, stdev= 4.12
    clat (msec): min=1, max=96, avg= 3.40, stdev= 3.27
     lat (msec): min=1, max=96, avg= 3.41, stdev= 3.27
    clat percentiles (usec):
     |  1.00th=[ 1432],  5.00th=[ 1592], 10.00th=[ 1704], 20.00th=[ 1848],
     | 30.00th=[ 2008], 40.00th=[ 2160], 50.00th=[ 2384], 60.00th=[ 2768],
     | 70.00th=[ 3696], 80.00th=[ 4768], 90.00th=[ 6112], 95.00th=[ 7264],
     | 99.00th=[10816], 99.50th=[15680], 99.90th=[47872], 99.95th=[65280],
     | 99.99th=[91648]
    bw (KB  /s): min=   32, max=522240, per=98.35%, avg=442699.63, stdev=64256.73
    lat (msec) : 2=29.84%, 4=42.92%, 10=26.01%, 20=0.90%, 50=0.24%
    lat (msec) : 100=0.08%
  cpu          : usr=4.50%, sys=8.91%, ctx=178974, majf=0, minf=3167
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=107.7%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=210985/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=24

Run status group 0 (all jobs):
  WRITE: io=13188MB, aggrb=450105KB/s, minb=450105KB/s, maxb=450105KB/s, mint=30003msec, maxt=30003msec

Disk stats (read/write):
  rbd0: ios=60/226569, merge=0/0, ticks=16/761906, in_queue=766757, util=99.91%
```

---

```
seq-read-4k: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=24
seq-read-4k: (groupid=0, jobs=1): err= 0: pid=1208681: Fri May 13 16:34:29 2016
  read : io=7511.6MB, bw=256385KB/s, iops=64095, runt= 30001msec
    slat (usec): min=7, max=102, avg=13.55, stdev= 3.48
    clat (usec): min=167, max=13178, avg=357.69, stdev=128.56
     lat (usec): min=178, max=13193, avg=371.32, stdev=129.27
    clat percentiles (usec):
     |  1.00th=[  201],  5.00th=[  221], 10.00th=[  233], 20.00th=[  255],
     | 30.00th=[  294], 40.00th=[  334], 50.00th=[  358], 60.00th=[  378],
     | 70.00th=[  406], 80.00th=[  434], 90.00th=[  474], 95.00th=[  516],
     | 99.00th=[  620], 99.50th=[  684], 99.90th=[ 1064], 99.95th=[ 1944],
     | 99.99th=[ 3440]
    bw (KB  /s): min=   16, max=281344, per=98.40%, avg=252272.27, stdev=34874.35
    lat (usec) : 250=18.28%, 500=75.36%, 750=6.07%, 1000=0.18%
    lat (msec) : 2=0.07%, 4=0.04%, 10=0.01%, 20=0.01%
  cpu          : usr=4.67%, sys=16.45%, ctx=382505, majf=0, minf=237
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.1%, 16=106.8%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=0.0%, 8=100.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=0.0%, 8=100.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=1922928/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=24

Run status group 0 (all jobs):
   READ: io=7511.6MB, aggrb=256384KB/s, minb=256384KB/s, maxb=256384KB/s, mint=30001msec, maxt=30001msec

Disk stats (read/write):
  rbd0: ios=255911/0, merge=1791398/0, ticks=92814/0, in_queue=92770, util=99.73%
```

---

```
seq-read-64k: (g=0): rw=read, bs=64K-64K/64K-64K/64K-64K, ioengine=libaio, iodepth=24
seq-read-64k: (groupid=0, jobs=1): err= 0: pid=1207296: Fri May 13 16:32:19 2016
  read : io=28759MB, bw=981590KB/s, iops=15336, runt= 30002msec
    slat (usec): min=25, max=374, avg=40.55, stdev=11.53
    clat (usec): min=236, max=25788, avg=1520.38, stdev=527.45
     lat (usec): min=269, max=25855, avg=1560.91, stdev=527.49
    clat percentiles (usec):
     |  1.00th=[  532],  5.00th=[  932], 10.00th=[ 1048], 20.00th=[ 1208],
     | 30.00th=[ 1288], 40.00th=[ 1336], 50.00th=[ 1400], 60.00th=[ 1464],
     | 70.00th=[ 1576], 80.00th=[ 1832], 90.00th=[ 2256], 95.00th=[ 2512],
     | 99.00th=[ 2960], 99.50th=[ 3152], 99.90th=[ 4128], 99.95th=[ 4768],
     | 99.99th=[12096]
    bw (KB  /s): min=  255, max=1108992, per=98.45%, avg=966372.47, stdev=149263.96
    lat (usec) : 250=0.01%, 500=0.79%, 750=1.56%, 1000=5.12%
    lat (msec) : 2=76.68%, 4=15.74%, 10=0.09%, 20=0.01%, 50=0.01%
  cpu          : usr=1.42%, sys=10.15%, ctx=93100, majf=0, minf=2396
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.1%, 16=107.2%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=0.0%, 8=100.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=0.0%, 8=100.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=460128/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=24

Run status group 0 (all jobs):
   READ: io=28759MB, aggrb=981590KB/s, minb=981590KB/s, maxb=981590KB/s, mint=30002msec, maxt=30002msec

Disk stats (read/write):
  rbd0: ios=61479/0, merge=430374/0, ticks=94084/0, in_queue=94055, util=99.74%
```

---

```
seq-write-4k: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=24
seq-write-4k: (groupid=0, jobs=1): err= 0: pid=1208003: Fri May 13 16:33:24 2016
  write: io=2012.4MB, bw=68684KB/s, iops=17170, runt= 30002msec
    slat (usec): min=7, max=99, avg=18.77, stdev= 6.16
    clat (usec): min=836, max=6976, avg=1374.18, stdev=273.32
     lat (usec): min=852, max=6997, avg=1392.99, stdev=273.70
    clat percentiles (usec):
     |  1.00th=[  988],  5.00th=[ 1080], 10.00th=[ 1128], 20.00th=[ 1192],
     | 30.00th=[ 1240], 40.00th=[ 1288], 50.00th=[ 1320], 60.00th=[ 1368],
     | 70.00th=[ 1432], 80.00th=[ 1512], 90.00th=[ 1656], 95.00th=[ 1816],
     | 99.00th=[ 2384], 99.50th=[ 2704], 99.90th=[ 3632], 99.95th=[ 4128],
     | 99.99th=[ 5984]
    bw (KB  /s): min=   16, max=71680, per=98.39%, avg=67580.77, stdev=8981.89
    lat (usec) : 1000=1.34%
    lat (msec) : 2=96.05%, 4=2.55%, 10=0.06%
  cpu          : usr=2.07%, sys=5.43%, ctx=71313, majf=0, minf=66
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.1%, 16=106.6%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=0.0%, 8=100.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=0.0%, 8=100.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=515144/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=24

Run status group 0 (all jobs):
  WRITE: io=2012.4MB, aggrb=68684KB/s, minb=68684KB/s, maxb=68684KB/s, mint=30002msec, maxt=30002msec

Disk stats (read/write):
  rbd0: ios=60/68422, merge=0/478975, ticks=20/94050, in_queue=94045, util=99.79%
```

---

```
seq-write-64k: (g=0): rw=write, bs=64K-64K/64K-64K/64K-64K, ioengine=libaio, iodepth=24
seq-write-64k: (groupid=0, jobs=1): err= 0: pid=1206554: Fri May 13 16:31:13 2016
  write: io=13003MB, bw=443806KB/s, iops=6933, runt= 30003msec
    slat (usec): min=22, max=122, avg=39.34, stdev=10.06
    clat (usec): min=2217, max=12360, avg=3413.39, stdev=531.08
     lat (usec): min=2253, max=12401, avg=3452.54, stdev=531.22
    clat percentiles (usec):
     |  1.00th=[ 2480],  5.00th=[ 2672], 10.00th=[ 2800], 20.00th=[ 2960],
     | 30.00th=[ 3088], 40.00th=[ 3216], 50.00th=[ 3344], 60.00th=[ 3472],
     | 70.00th=[ 3632], 80.00th=[ 3824], 90.00th=[ 4128], 95.00th=[ 4384],
     | 99.00th=[ 4832], 99.50th=[ 5088], 99.90th=[ 5792], 99.95th=[ 6368],
     | 99.99th=[11712]
    bw (KB  /s): min=  255, max=458858, per=98.44%, avg=436893.02, stdev=57640.04
    lat (msec) : 4=86.97%, 10=13.02%, 20=0.02%
  cpu          : usr=1.84%, sys=3.64%, ctx=38043, majf=0, minf=426
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.1%, 16=106.6%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=0.0%, 8=100.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=0.0%, 8=100.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=208032/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=24

Run status group 0 (all jobs):
  WRITE: io=13003MB, aggrb=443806KB/s, minb=443806KB/s, maxb=443806KB/s, mint=30003msec, maxt=30003msec

Disk stats (read/write):
  rbd0: ios=60/27636, merge=0/193473, ticks=19/94745, in_queue=94752, util=99.79%
```
