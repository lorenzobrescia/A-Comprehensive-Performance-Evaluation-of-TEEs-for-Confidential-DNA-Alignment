# Microbenchmarks

We provided a portable way for install and launch [Phoronix Test Suite](https://openbenchmarking.org/suites) microbenchmarks.

In the `install_benchmarks.sh` file there are all the test that you want to run.

In the `run_benchmarks.sh` file the test are executed one after the other.

In the `test_names.json` there are all the name tests in the phoronix test suite.

The `user-config.xml` file it is necessary to performs all the microbenchmarks in batch.

Finally the `Dockerfile` will create the Docker image with all the tests installed. Then it is just necessary to build the image, run the container and attach to it to finally running the benchmarks:
```bash
docker build -t micro:performance . 
docker run -itd --name micro micro:performance
docker attach micro
nohup ./run_benchmarks.sh
```

Retrieve all `.log` results, before to stop and remove the container.
```bash
docker cp micro:/root/results .
```

Now you have a folder `results` with all log files of the microbenchmark.
These files can be further processed to obtain JSON structured files, by using the `clean_log_files.py` script.
```bash 
python3 clean_log_files.py results
```

It will create `results/cleaned` folder with all escaped log files and a `results/cleaned/result.json` file with all the test structured in json like the following:
```json
[
  {
    "pts/hackbench-1.0.0": [
      {
        "description": "Count: 1 - Type: Thread",
        "values": [
          2.747,
          2.748,
          2.892,
          2.919,
          2.656,
          2.763,
          2.653,
          2.709,
          2.866,
          2.795,
          2.689,
          2.688,
          2.734,
          2.698,
          2.686
        ],
        "unit": "Seconds",
        "average": 2.749533333333334,
        "std_dev": 0.08121236906339382
      },
      {
        "description": "Count: 2 - Type: Thread",
        "values": [
          4.212,
          4.281,
          4.342
        ],
        "unit": "Seconds",
        "average": 4.278333333333332,
        "std_dev": 0.05310576449145815
      },
      {
        "description": "Count: 4 - Type: Thread",
        "values": [
          8.091,
          8.126,
          8.163
        ],
        "unit": "Seconds",
        "average": 8.126666666666667,
        "std_dev": 0.02939765674713284
      },
      {
        "description": "Count: 8 - Type: Thread",
        "values": [
          14.642,
          14.502,
          14.607
        ],
        "unit": "Seconds",
        "average": 14.583666666666666,
        "std_dev": 0.05948856099191525
      },
      {
        "description": "Count: 1 - Type: Process",
        "values": [
          2.731,
          2.646,
          2.686
        ],
        "unit": "Seconds",
        "average": 2.6876666666666664,
        "std_dev": 0.03472111109333275
      },
      {
        "description": "Count: 16 - Type: Thread",
        "values": [
          25.161,
          25.398,
          25.31
        ],
        "unit": "Seconds",
        "average": 25.289666666666665,
        "std_dev": 0.09781728999630927
      },
      {
        "description": "Count: 2 - Type: Process",
        "values": [
          4.342,
          4.345,
          4.252
        ],
        "unit": "Seconds",
        "average": 4.313,
        "std_dev": 0.0431508980207828
      },
      {
        "description": "Count: 32 - Type: Thread",
        "values": [
          50.381,
          50.39,
          50.43
        ],
        "unit": "Seconds",
        "average": 50.40033333333333,
        "std_dev": 0.02129684379328409
      },
      {
        "description": "Count: 4 - Type: Process",
        "values": [
          7.891,
          7.865,
          7.823
        ],
        "unit": "Seconds",
        "average": 7.859666666666667,
        "std_dev": 0.028015868519267434
      },
      {
        "description": "Count: 8 - Type: Process",
        "values": [
          14.042,
          14.094,
          14.166
        ],
        "unit": "Seconds",
        "average": 14.100666666666667,
        "std_dev": 0.050841802573167234
      },
      {
        "description": "Count: 16 - Type: Process",
        "values": [
          24.695,
          24.61,
          24.629
        ],
        "unit": "Seconds",
        "average": 24.644666666666666,
        "std_dev": 0.03642648609032852
      },
      {
        "description": "Count: 32 - Type: Process",
        "values": [
          50.699,
          50.696,
          50.796
        ],
        "unit": "Seconds",
        "average": 50.730333333333334,
        "std_dev": 0.046449494674922084
      }
    ]
  },
  {
    "pts/cachebench-1.2.0": [
      {
        "description": "Test: Read",
        "values": [
          9404.792157,
          9405.218233,
          9405.484625
        ],
        "unit": "MB/s",
        "average": 9405.165005,
        "std_dev": 0.28519338204541855
      },
      {
        "description": "Test: Write",
        "values": [
          56363.307323,
          56356.34726,
          56356.561183
        ],
        "unit": "MB/s",
        "average": 56358.73858866666,
        "std_dev": 3.23176327711044
      },
      {
        "description": "Test: Read / Modify / Write",
        "values": [
          107804.161002,
          107620.765901,
          107666.242871
        ],
        "unit": "MB/s",
        "average": 107697.05659133331,
        "std_dev": 77.9767263922798
      }
    ]
  },
  {
    "pts/ramspeed-1.4.3": [
      {
        "description": "Type: Add - Benchmark: Integer",
        "values": [
          42361.38,
          42638.36,
          42562.66
        ],
        "unit": "MB/s",
        "average": 42520.799999999996,
        "std_dev": 116.88648282272459
      },
      {
        "description": "Type: Copy - Benchmark: Integer",
        "values": [
          42697.62,
          43466.64,
          42737.14
        ],
        "unit": "MB/s",
        "average": 42967.13333333334,
        "std_dev": 353.572849762094
      },
      {
        "description": "Type: Scale - Benchmark: Integer",
        "values": [
          42663.76,
          43389.51,
          43744.85
        ],
        "unit": "MB/s",
        "average": 43266.04,
        "std_dev": 449.90556616546274
      },
      {
        "description": "Type: Triad - Benchmark: Integer",
        "values": [
          41759.42,
          41994.04,
          41934.92
        ],
        "unit": "MB/s",
        "average": 41896.12666666666,
        "std_dev": 99.6337564393835
      },
      {
        "description": "Type: Average - Benchmark: Integer",
        "values": [
          41591.61,
          42669.48,
          41861.26
        ],
        "unit": "MB/s",
        "average": 42040.78333333333,
        "std_dev": 457.9828269220981
      },
      {
        "description": "Type: Add - Benchmark: Floating Point",
        "values": [
          41319.9,
          42372.43,
          41899.2
        ],
        "unit": "MB/s",
        "average": 41863.84333333333,
        "std_dev": 430.4202757254299
      },
      {
        "description": "Type: Copy - Benchmark: Floating Point",
        "values": [
          40113.27,
          41890.76,
          42402.26,
          43113.4,
          41394.53,
          41475.44
        ],
        "unit": "MB/s",
        "average": 41731.61,
        "std_dev": 929.4007119285719
      },
      {
        "description": "Type: Scale - Benchmark: Floating Point",
        "values": [
          42650.28,
          44062.28,
          43829.57
        ],
        "unit": "MB/s",
        "average": 43514.043333333335,
        "std_dev": 618.1174688969369
      },
      {
        "description": "Type: Triad - Benchmark: Floating Point",
        "values": [
          41424.53,
          41547.95,
          41060.74
        ],
        "unit": "MB/s",
        "average": 41344.40666666667,
        "std_dev": 206.81426036153508
      },
      {
        "description": "Type: Average - Benchmark: Floating Point",
        "values": [
          42578.34,
          43015.37,
          42929.9
        ],
        "unit": "MB/s",
        "average": 42841.20333333333,
        "std_dev": 189.11923793087936
      }
    ]
  },
  {
    "pts/osbench-1.0.2": [
      {
        "description": "Test: Create Files",
        "values": [
          21.312618,
          21.054979,
          21.202766
        ],
        "unit": "us Per Event",
        "average": 21.190121,
        "std_dev": 0.10556004799481082
      },
      {
        "description": "Test: Create Threads",
        "values": [
          23.047924,
          21.729469,
          21.409988,
          22.408962,
          22.201538,
          22.947788,
          23.560524,
          23.579597,
          22.039413,
          23.050308,
          19.848347,
          22.318363,
          21.74139,
          21.162033,
          22.029877
        ],
        "unit": "us Per Event",
        "average": 22.20503473333333,
        "std_dev": 0.9497724305864337
      },
      {
        "description": "Test: Launch Programs",
        "values": [
          53.150654,
          54.371357,
          53.231716
        ],
        "unit": "us Per Event",
        "average": 53.584575666666666,
        "std_dev": 0.5573218171591319
      },
      {
        "description": "Test: Create Processes",
        "values": [
          47.459602,
          47.140121,
          47.34993
        ],
        "unit": "us Per Event",
        "average": 47.316551000000004,
        "std_dev": 0.1325459557310833
      },
      {
        "description": "Test: Memory Allocations",
        "values": [
          86.750031,
          83.595991,
          83.787918
        ],
        "unit": "Ns Per Event",
        "average": 84.71131333333334,
        "std_dev": 1.443718875362362
      }
    ]
  },
  {
    "pts/sysbench-1.1.0": [
      {
        "description": "Test: RAM / Memory",
        "values": [
          10175.95,
          10202.5,
          10186.35
        ],
        "unit": "MiB/sec",
        "average": 10188.266666666668,
        "std_dev": 10.923394873186133
      },
      {
        "description": "Test: CPU",
        "values": [
          75096.34,
          75120.72,
          75098.05
        ],
        "unit": "Events Per Second",
        "average": 75105.03666666667,
        "std_dev": 11.11174253761493
      }
    ]
  },
  {
    "pts/stream-1.3.4": [
      {
        "description": "Type: Copy",
        "values": [
          60206.8,
          60420.9,
          60229.5,
          60281.9,
          60359.5
        ],
        "unit": "MB/s",
        "average": 60299.719999999994,
        "std_dev": 80.17576691245274
      },
      {
        "description": "Type: Scale",
        "values": [
          42764.7,
          42869,
          42961.2,
          42850.4,
          42834.5
        ],
        "unit": "MB/s",
        "average": 42855.96,
        "std_dev": 63.348767943820185
      },
      {
        "description": "Type: Triad",
        "values": [
          48295.5,
          48384.2,
          48439.8,
          48389.1,
          48327.5
        ],
        "unit": "MB/s",
        "average": 48367.22,
        "std_dev": 50.51009404069698
      },
      {
        "description": "Type: Add",
        "values": [
          48114.5,
          48166.6,
          47963.5,
          48155,
          48203.5
        ],
        "unit": "MB/s",
        "average": 48120.62,
        "std_dev": 83.53369140652156
      }
    ]
  },
  {
    "pts/stress-ng-1.13.0": [
      {
        "description": "Test: Hash",
        "values": [
          3766607.12,
          3770153.66,
          3766246.77
        ],
        "unit": "Bogo Ops/s",
        "average": 3767669.1833333336,
        "std_dev": 1762.939072691502
      },
      {
        "description": "Test: MMAP",
        "values": [
          1403.56,
          1396.63,
          1396.89
        ],
        "unit": "Bogo Ops/s",
        "average": 1399.0266666666666,
        "std_dev": 3.2073076282486124
      },
      {
        "description": "Test: Pipe",
        "values": [
          12815751.93,
          12738611.21,
          12835907.62
        ],
        "unit": "Bogo Ops/s",
        "average": 12796756.92,
        "std_dev": 41930.54299192901
      },
      {
        "description": "Test: Poll",
        "values": [
          2242868.81,
          2249832.53,
          2246297.98
        ],
        "unit": "Bogo Ops/s",
        "average": 2246333.106666667,
        "std_dev": 2843.0352878138797
      },
      {
        "description": "Test: Zlib",
        "values": [
          2036.97,
          2038.55,
          2035.49
        ],
        "unit": "Bogo Ops/s",
        "average": 2037.0033333333333,
        "std_dev": 1.2494621064904285
      },
      {
        "description": "Test: Futex",
        "values": [
          2660529.56,
          2610482.61,
          2527164.99,
          2425379.74,
          2537219.15,
          2682848.62,
          2614175.4,
          2538815.02,
          2558619.42,
          2544059.83,
          2630608.62,
          2589320.27,
          2704509.85,
          2781081.74,
          2709200.63
        ],
        "unit": "Bogo Ops/s",
        "average": 2607601.0300000003,
        "std_dev": 87553.56708995806
      },
      {
        "description": "Test: MEMFD",
        "values": [
          1968.71,
          1969.99,
          1971.15
        ],
        "unit": "Bogo Ops/s",
        "average": 1969.95,
        "std_dev": 0.9965273035229439
      },
      {
        "description": "Test: Mutex",
        "values": [
          8991495.31,
          9014402.28,
          9006043.5
        ],
        "unit": "Bogo Ops/s",
        "average": 9003980.363333333,
        "std_dev": 9464.83732292742
      },
      {
        "description": "Test: Atomic",
        "values": [
          224.48,
          224.65,
          224.55
        ],
        "unit": "Bogo Ops/s",
        "average": 224.56000000000003,
        "std_dev": 0.06976149845486031
      },
      {
        "description": "Test: Crypto",
        "values": [
          217025682.02,
          216516125.22,
          221036748.28
        ],
        "unit": "Bogo Ops/s",
        "average": 218192851.84,
        "std_dev": 2021669.6489436743
      },
      {
        "description": "Test: Malloc",
        "values": [
          46195751.22,
          47808035.06,
          48181712.03
        ],
        "unit": "Bogo Ops/s",
        "average": 47395166.10333333,
        "std_dev": 861725.2718619138
      },
      {
        "description": "Test: Cloning",
        "values": [
          3709.66,
          3449.34,
          3444.65,
          3349.84,
          3418.7,
          3399.75,
          3364.5,
          3374.02,
          3392.55,
          3376.2,
          3390.13,
          3334.65,
          3398,
          3321.04,
          3306.21
        ],
        "unit": "Bogo Ops/s",
        "average": 3401.949333333333,
        "std_dev": 91.31870611338191
      },
      {
        "description": "Test: Forking",
        "values": [
          71617.59,
          72001.23,
          69943.75
        ],
        "unit": "Bogo Ops/s",
        "average": 71187.52333333333,
        "std_dev": 893.3174094103127
      },
      {
        "description": "Test: Pthread",
        "values": [
          194332.52,
          189500.17,
          193690.49
        ],
        "unit": "Bogo Ops/s",
        "average": 192507.72666666665,
        "std_dev": 2142.7549957369156
      },
      {
        "description": "Test: AVL Tree",
        "values": [
          199.88,
          200.01,
          200.18
        ],
        "unit": "Bogo Ops/s",
        "average": 200.0233333333333,
        "std_dev": 0.12283683848459352
      },
      {
        "description": "Test: SENDFILE",
        "values": [
          321401.94,
          327957.2,
          326844.74
        ],
        "unit": "Bogo Ops/s",
        "average": 325401.29333333333,
        "std_dev": 2864.2057801460824
      },
      {
        "description": "Test: CPU Cache",
        "values": [
          1201951.9,
          1192997.03,
          1182455.93
        ],
        "unit": "Bogo Ops/s",
        "average": 1192468.2866666664,
        "std_dev": 7967.972920579534
      },
      {
        "description": "Test: CPU Stress",
        "values": [
          41510.43,
          40749.82,
          40741.06
        ],
        "unit": "Bogo Ops/s",
        "average": 41000.43666666667,
        "std_dev": 360.6374767300575
      },
      {
        "description": "Test: Power Math",
        "values": [
          34820.77,
          34891.95,
          34864.15
        ],
        "unit": "Bogo Ops/s",
        "average": 34858.956666666665,
        "std_dev": 29.290227418411156
      },
      {
        "description": "Test: Semaphores",
        "values": [
          34968651.57,
          38394548.33,
          34754911.28,
          33790374.96,
          35047338.85,
          30818728.62,
          37197897.79,
          39274508.41,
          34230299.42,
          36326850.4,
          37340437.91,
          39274821.98,
          37477328.57,
          36534924.21,
          35798798.94
        ],
        "unit": "Bogo Ops/s",
        "average": 36082028.082666665,
        "std_dev": 2180349.0753063094
      },
      {
        "description": "Test: Matrix Math",
        "values": [
          92056.2,
          92017.89,
          92058.67
        ],
        "unit": "Bogo Ops/s",
        "average": 92044.25333333334,
        "std_dev": 18.668944503877533
      },
      {
        "description": "Test: Vector Math",
        "values": [
          125182.82,
          125184.37,
          125149.01
        ],
        "unit": "Bogo Ops/s",
        "average": 125172.06666666667,
        "std_dev": 16.31580079418868
      },
      {
        "description": "Test: AVX-512 VNNI",
        "values": [
          1890967.16,
          1892548.16,
          1886451.78
        ],
        "unit": "Bogo Ops/s",
        "average": 1889989.0333333332,
        "std_dev": 2583.151964575183
      },
      {
        "description": "Test: Integer Math",
        "values": [
          1485122.61,
          1485832.49,
          1485678.27
        ],
        "unit": "Bogo Ops/s",
        "average": 1485544.4566666668,
        "std_dev": 304.8627119795509
      },
      {
        "description": "Test: Function Call",
        "values": [
          14342.09,
          14446.3,
          14310.3
        ],
        "unit": "Bogo Ops/s",
        "average": 14366.230000000001,
        "std_dev": 58.08645682658439
      },
      {
        "description": "Test: x86_64 RdRand",
        "values": [
          6025892.25,
          6025064.51,
          6024831.02
        ],
        "unit": "Bogo Ops/s",
        "average": 6025262.593333334,
        "std_dev": 455.3240848989289
      },
      {
        "description": "Test: Floating Point",
        "values": [
          3316.87,
          3315.03,
          3317.47
        ],
        "unit": "Bogo Ops/s",
        "average": 3316.4566666666665,
        "std_dev": 1.038117955190321
      },
      {
        "description": "Test: Matrix 3D Math",
        "values": [
          2378.62,
          2375.27,
          2387.11
        ],
        "unit": "Bogo Ops/s",
        "average": 2380.3333333333335,
        "std_dev": 4.98317391049349
      },
      {
        "description": "Test: Memory Copying",
        "values": [
          4310.96,
          4311.69,
          4310.34
        ],
        "unit": "Bogo Ops/s",
        "average": 4310.996666666667,
        "std_dev": 0.5517447074707401
      },
      {
        "description": "Test: Vector Shuffle",
        "values": [
          12348.28,
          12345.93,
          12354.1
        ],
        "unit": "Bogo Ops/s",
        "average": 12349.436666666666,
        "std_dev": 3.434203773155504
      },
      {
        "description": "Test: Mixed Scheduler",
        "values": [
          24335.67,
          24678.01,
          25323.03
        ],
        "unit": "Bogo Ops/s",
        "average": 24778.903333333332,
        "std_dev": 409.3527744568928
      },
      {
        "description": "Test: Socket Activity",
        "values": [
          21016.04,
          21941.79,
          21403.94
        ],
        "unit": "Bogo Ops/s",
        "average": 21453.923333333336,
        "std_dev": 379.5848748596581
      },
      {
        "description": "Test: Exponential Math",
        "values": [
          75255.1,
          75223.42,
          75228.84
        ],
        "unit": "Bogo Ops/s",
        "average": 75235.78666666667,
        "std_dev": 13.83468427138814
      },
      {
        "description": "Test: Jpeg Compression",
        "values": [
          19787.3,
          19811.8,
          19757.13
        ],
        "unit": "Bogo Ops/s",
        "average": 19785.41,
        "std_dev": 22.358910229853194
      },
      {
        "description": "Test: Logarithmic Math",
        "values": [
          112617.41,
          112670.73,
          112660.72
        ],
        "unit": "Bogo Ops/s",
        "average": 112649.62,
        "std_dev": 23.139621143539557
      },
      {
        "description": "Test: Wide Vector Math",
        "values": [
          1263446.99,
          1263186.11,
          1263300.31
        ],
        "unit": "Bogo Ops/s",
        "average": 1263311.1366666667,
        "std_dev": 106.77860626336049
      },
      {
        "description": "Test: Context Switching",
        "values": [
          7889310.42,
          7932220.58,
          7874118.03
        ],
        "unit": "Bogo Ops/s",
        "average": 7898549.676666667,
        "std_dev": 24603.5156964749
      },
      {
        "description": "Test: Fractal Generator",
        "values": [
          140.57,
          140.57,
          140.53
        ],
        "unit": "Bogo Ops/s",
        "average": 140.55666666666664,
        "std_dev": 0.018856180831637516
      },
      {
        "description": "Test: Radix String Sort",
        "values": [
          210.75,
          210.38,
          210.58
        ],
        "unit": "Bogo Ops/s",
        "average": 210.57000000000002,
        "std_dev": 0.15121728296285225
      },
      {
        "description": "Test: Fused Multiply-Add",
        "values": [
          22365738.94,
          22338107.87,
          22333982.01
        ],
        "unit": "Bogo Ops/s",
        "average": 22345942.94,
        "std_dev": 14098.862653535774
      },
      {
        "description": "Test: Trigonometric Math",
        "values": [
          43785,
          43946.99,
          43946.81
        ],
        "unit": "Bogo Ops/s",
        "average": 43892.93333333333,
        "std_dev": 76.32042729323562
      },
      {
        "description": "Test: Bitonic Integer Sort",
        "values": [
          150.43,
          150.43,
          150.37
        ],
        "unit": "Bogo Ops/s",
        "average": 150.41,
        "std_dev": 0.028284271247462973
      },
      {
        "description": "Test: Vector Floating Point",
        "values": [
          64598.9,
          64534.49,
          64575.11
        ],
        "unit": "Bogo Ops/s",
        "average": 64569.5,
        "std_dev": 26.592807298216528
      },
      {
        "description": "Test: Bessel Math Operations",
        "values": [
          10433.05,
          10459.02,
          10477.28
        ],
        "unit": "Bogo Ops/s",
        "average": 10456.449999999999,
        "std_dev": 18.14803754312537
      },
      {
        "description": "Test: Integer Bit Operations",
        "values": [
          3247439.39,
          3256246.59,
          3256227.37
        ],
        "unit": "Bogo Ops/s",
        "average": 3253304.4500000007,
        "std_dev": 4147.231120864387
      },
      {
        "description": "Test: Glibc C String Functions",
        "values": [
          21845998.24,
          21719564.7,
          20640885.09,
          21856895.64,
          20477805.76,
          21046177.04,
          20640320.78,
          21845548.75,
          21810084.02,
          21835929.66,
          21719364.26,
          21840132.93,
          19547365.4,
          20376946.79,
          20071392.62
        ],
        "unit": "Bogo Ops/s",
        "average": 21151627.445333336,
        "std_dev": 766375.6616233868
      },
      {
        "description": "Test: Glibc Qsort Data Sorting",
        "values": [
          473.3,
          475.73,
          473.97
        ],
        "unit": "Bogo Ops/s",
        "average": 474.3333333333333,
        "std_dev": 1.0247709771239415
      },
      {
        "description": "Test: System V Message Passing",
        "values": [
          18253597.93,
          18204454.3,
          18113146.44
        ],
        "unit": "Bogo Ops/s",
        "average": 18190399.55666667,
        "std_dev": 58193.96943801721
      },
      {
        "description": "Test: POSIX Regular Expressions",
        "values": [
          129972.53,
          130365.41,
          129967.02
        ],
        "unit": "Bogo Ops/s",
        "average": 130101.65333333334,
        "std_dev": 186.51769251795542
      },
      {
        "description": "Test: Hyperbolic Trigonometric Math",
        "values": [
          86020.62,
          85957.59,
          85954.24
        ],
        "unit": "Bogo Ops/s",
        "average": 85977.48333333334,
        "std_dev": 30.532874450697456
      }
    ]
  },
  {
    "pts/mutex-1.0.0": [
      {
        "description": "Benchmark: Shared Mutex Lock Shared",
        "values": [
          18.7,
          18.7,
          18.7
        ],
        "unit": "ns",
        "average": 18.7,
        "std_dev": 0
      },
      {
        "description": "Benchmark: Mutex Lock Unlock spinlock",
        "values": [
          23.6,
          23.6,
          23.6
        ],
        "unit": "ns",
        "average": 23.600000000000005,
        "std_dev": 3.552713678800501e-15
      },
      {
        "description": "Benchmark: Mutex Lock Unlock std::mutex",
        "values": [
          14.1,
          14.1,
          14.1
        ],
        "unit": "ns",
        "average": 14.1,
        "std_dev": 0
      },
      {
        "description": "Benchmark: Mutex Lock Unlock std::mutex",
        "values": [
          18.4,
          18.1,
          18.1
        ],
        "unit": "ns",
        "average": 18.2,
        "std_dev": 0.14142135623730814
      },
      {
        "description": "Benchmark: Semaphore Release And Acquire",
        "values": [
          9.04,
          9.05,
          9.11
        ],
        "unit": "ns",
        "average": 9.066666666666666,
        "std_dev": 0.0309120616516522
      },
      {
        "description": "Benchmark: Mutex Lock Unlock spinlock_amd",
        "values": [
          26.7,
          26.6,
          26.7
        ],
        "unit": "ns",
        "average": 26.666666666666668,
        "std_dev": 0.04714045207910217
      },
      {
        "description": "Benchmark: Mutex Lock Unlock pthread_mutex",
        "values": [
          10.3,
          10.3,
          10.3
        ],
        "unit": "ns",
        "average": 10.3,
        "std_dev": 0
      },
      {
        "description": "Benchmark: Mutex Lock Unlock ticket_spinlock",
        "values": [
          16.8,
          16.8,
          16.8
        ],
        "unit": "ns",
        "average": 16.8,
        "std_dev": 0
      }
    ]
  },
  {
    "pts/ipc-benchmark-1.0.0": [
      {
        "description": "Type: TCP Socket - Message Bytes: 128",
        "values": [
          3671551,
          3749386,
          3711215
        ],
        "unit": "Messages Per Second",
        "average": 3710717.3333333335,
        "std_dev": 31777.954206580944
      },
      {
        "description": "Type: TCP Socket - Message Bytes: 256",
        "values": [
          3312909,
          3270854,
          3281608
        ],
        "unit": "Messages Per Second",
        "average": 3288457,
        "std_dev": 17838.859399262798
      },
      {
        "description": "Type: TCP Socket - Message Bytes: 512",
        "values": [
          2626952,
          2728463,
          2681692
        ],
        "unit": "Messages Per Second",
        "average": 2679035.6666666665,
        "std_dev": 41484.23684833661
      },
      {
        "description": "Type: TCP Socket - Message Bytes: 1024",
        "values": [
          2241823,
          2187151,
          2194034
        ],
        "unit": "Messages Per Second",
        "average": 2207669.3333333335,
        "std_dev": 24313.214957211138
      },
      {
        "description": "Type: TCP Socket - Message Bytes: 2048",
        "values": [
          1561858,
          1556915,
          1453338,
          1558744,
          1462431,
          1449766,
          1459696,
          1557907,
          1468184,
          1559546,
          1546619,
          1465105,
          1466625,
          1458691,
          1455762
        ],
        "unit": "Messages Per Second",
        "average": 1498745.8,
        "std_dev": 47825.48302205983
      },
      {
        "description": "Type: TCP Socket - Message Bytes: 4096",
        "values": [
          926880,
          925300,
          917555
        ],
        "unit": "Messages Per Second",
        "average": 923245,
        "std_dev": 4074.8149242225304
      },
      {
        "description": "Type: Unnamed Pipe - Message Bytes: 128",
        "values": [
          3949839,
          4001341,
          3927481
        ],
        "unit": "Messages Per Second",
        "average": 3959553.6666666665,
        "std_dev": 30925.781707536873
      },
      {
        "description": "Type: Unnamed Pipe - Message Bytes: 256",
        "values": [
          3617689,
          3733569,
          3730395
        ],
        "unit": "Messages Per Second",
        "average": 3693884.3333333335,
        "std_dev": 53893.81649956597
      },
      {
        "description": "Type: Unnamed Pipe - Message Bytes: 512",
        "values": [
          3619483,
          3421586,
          3602842,
          3570279,
          3570373
        ],
        "unit": "Messages Per Second",
        "average": 3556912.6,
        "std_dev": 70281.85601590214
      },
      {
        "description": "Type: Unnamed Pipe - Message Bytes: 1024",
        "values": [
          3057994,
          3043768,
          3040169
        ],
        "unit": "Messages Per Second",
        "average": 3047310.3333333335,
        "std_dev": 7696.048784206666
      },
      {
        "description": "Type: Unnamed Pipe - Message Bytes: 2048",
        "values": [
          2250146,
          2221777,
          2189921
        ],
        "unit": "Messages Per Second",
        "average": 2220614.6666666665,
        "std_dev": 24600.48672056894
      },
      {
        "description": "Type: Unnamed Pipe - Message Bytes: 4096",
        "values": [
          1534488,
          1563187,
          1504984
        ],
        "unit": "Messages Per Second",
        "average": 1534219.6666666667,
        "std_dev": 23762.032802117097
      },
      {
        "description": "Type: FIFO Named Pipe - Message Bytes: 128",
        "values": [
          4463469,
          4305761,
          4474993
        ],
        "unit": "Messages Per Second",
        "average": 4414741,
        "std_dev": 77203.97633973698
      },
      {
        "description": "Type: FIFO Named Pipe - Message Bytes: 256",
        "values": [
          4144805,
          4182311,
          4128605
        ],
        "unit": "Messages Per Second",
        "average": 4151907,
        "std_dev": 22493.145800443297
      },
      {
        "description": "Type: FIFO Named Pipe - Message Bytes: 512",
        "values": [
          3785707,
          3713428,
          3765867
        ],
        "unit": "Messages Per Second",
        "average": 3755000.6666666665,
        "std_dev": 30491.76238848052
      },
      {
        "description": "Type: FIFO Named Pipe - Message Bytes: 1024",
        "values": [
          3347204,
          3324832,
          3285117
        ],
        "unit": "Messages Per Second",
        "average": 3319051,
        "std_dev": 25674.421291757808
      },
      {
        "description": "Type: FIFO Named Pipe - Message Bytes: 2048",
        "values": [
          2319108,
          2338668,
          2083465,
          2221039,
          2190878,
          2267021,
          2282356,
          2297684,
          2209462,
          2307555,
          2073078,
          2254101,
          2190077,
          2214590,
          2239248
        ],
        "unit": "Messages Per Second",
        "average": 2232555.3333333335,
        "std_dev": 75271.06080087411
      },
      {
        "description": "Type: FIFO Named Pipe - Message Bytes: 4096",
        "values": [
          1545288,
          1573161,
          1532499
        ],
        "unit": "Messages Per Second",
        "average": 1550316,
        "std_dev": 16976.65355716491
      },
      {
        "description": "Type: Unnamed Unix Domain Socket - Message Bytes: 128",
        "values": [
          1274169,
          1116531,
          1633176,
          1201370,
          1162925,
          1632354,
          1521514,
          1204938,
          1100369,
          1005994,
          1244758,
          1400478,
          1338791,
          1318614,
          1093360
        ],
        "unit": "Messages Per Second",
        "average": 1283289.4,
        "std_dev": 186586.60770369705
      },
      {
        "description": "Type: Unnamed Unix Domain Socket - Message Bytes: 256",
        "values": [
          1059729,
          1304741,
          1178086,
          988396,
          1356562,
          1273349,
          1737990,
          1811548,
          1763772,
          1503012,
          1744061,
          1291195
        ],
        "unit": "Messages Per Second",
        "average": 1417703.4166666667,
        "std_dev": 276051.889312637
      },
      {
        "description": "Type: Unnamed Unix Domain Socket - Message Bytes: 512",
        "values": [
          1865992,
          1819968,
          1841606
        ],
        "unit": "Messages Per Second",
        "average": 1842522,
        "std_dev": 18800.380067080205
      },
      {
        "description": "Type: Unnamed Unix Domain Socket - Message Bytes: 1024",
        "values": [
          1707958,
          1699335,
          1701849
        ],
        "unit": "Messages Per Second",
        "average": 1703047.3333333333,
        "std_dev": 3620.8686189304844
      },
      {
        "description": "Type: Unnamed Unix Domain Socket - Message Bytes: 2048",
        "values": [
          1157808,
          1170005,
          1157291
        ],
        "unit": "Messages Per Second",
        "average": 1161701.3333333333,
        "std_dev": 5875.371326326721
      },
      {
        "description": "Type: Unnamed Unix Domain Socket - Message Bytes: 4096",
        "values": [
          1117277,
          1116160,
          1109846
        ],
        "unit": "Messages Per Second",
        "average": 1114427.6666666667,
        "std_dev": 3271.663627099964
      }
    ]
  }
]
```