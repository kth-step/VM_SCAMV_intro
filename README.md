# SCAM-V (Validation of Abstract Side-Channel Models for Computer Architectures)
In our paper, we describe a method to generate test inputs to validate side-channel models.
The implementation thereof is called SCAM-V and consists of a test input generation tool and a number of models together with a hardware benchmark platform.
The tool has been packaged in this VM together with our evaluation results.
However, the actual evaluation of the tool generated test inputs requires a benchmark platform, which can be built with a bit of special hardware according to the documentation in the repository we have made available through the GitHub project [EmbExp-Box](https://github.com/kth-step/EmbExp-Box).

In order to simplify the evaluation process, we have given access to our benchmark platform for this VM.
This way, an evaluator is able to generate test inputs and execute them on the actual hardware benchmark platform remotely without requiring to invest in building an experiment setup first.
Note that the process of executing test cases remotely requires internet access for the VM and the possibility to establish an SSH connection to `tcs79.csc.kth.se` on port `4422`.
The alternative is to build a local [`EmbExp-Box`](https://github.com/kth-step/EmbExp-Box) instance with a Raspberry Pi 3 board interfaced with appropriate JTAG and UART connections.

The evaluators may need to coordinate their efforts because whole experiment sets take long to execute and the hardware resources in our benchmark platform are limited.
We currently only have 4 instances of Raspberry Pi 3 available and one of us may also use one instance during the evaluation process.
Furthermore, be aware that the hardware sometimes exhibits hardware issues as mentioned in the [`EmbExp-Logs`](https://github.com/kth-step/EmbExp-Logs) README document, in the end of section "Validating experiments and cache inspection".

## 1. The results presented in the paper
The first step is to review the results presented in this paper.
These are the result of generating test inputs, or experiments, using the tool SCAM-V and the execution of these experiments on our benchmark platform.

### Experiment sets
When Scam-V generates test cases, it stores them in a SQLite
database. At first, the database contains experiments that have not
been executed yet. After executing them on a board, their outputs are
stored in the database and they are ready for evaluation. The git
repository containing the database and the scripts needed to drive
Scam-V in `HolBA_logs/EmbExp-Logs`. More detailed information about
how to use the scripts are in the GitHub project
[`EmbExp-Logs`](https://github.com/kth-step/EmbExp-Logs). The scripts
reside in the directory `scripts` and all of them provide basic usage
information if executed with the command line switch `--help`. Each
bash terminal in the VM always has the HolBA environment loaded.

### Evaluating experiment sets
The script `db-eval.py` in the `scamv/HolBA_logs/EmbExp-logs/scripts`
directory can be used to present the results of an experiment set
execution. Its command-line option `--dbfile` can be used to select
the experiment database of interest. The details about the evaluation
of individual experiments and sets is described in the
[`EmbExp-Logs`](https://github.com/kth-step/EmbExp-Logs) README
document.  Here is an example output of this script taken from our
prefetching experiments:

```
SCAM-V/HolBA run id: 2021-04-05_18-19-13_541
==================================================
exps_list_id = 1
progs_list_id = 1
scamv arguments = -i 450 -t 40 --prog_size 5 --enumerate --generator prefetch_strides --obs_model cache_tag_index_part --hw_obs_model hw_cache_tag_index_part

logged scamv gen run time = Duration: 31931.859s

numprogswithresult = 450
numprogswithcounterexample = 89

numexps = 18000
numexpswithresult = 18000
numexpsascounterexamples = 447
numexpsasinconclusive = 4709
numexpsasexception = 0

firstcounterexample_id = 398
```
The fields of the output are to be interpreted as follows:

- numprogswithresult: Number of programs that produced a result
- numprogswithcounterexample: Number of programs that produced at
  least one counterexample
- numexps: Number of experiments in the set
- numexpswithresult: Number of experiments that produced a result
- numexpsascounterexamples: Number of experiments that were counterexamples
  (distinguishable)
- numexpsasinconclusive: Number of experiments that were inconclusive
- numexpsasexception: Number of experiments that throw an exception at
  runtime
- firstcounterexample_id: The id of the experiment that was the first found
  counterexample. Used to compute ``time to first counterexample''.

In this output we see that SCAM-V generated 450 programs and 18000 experiments,
of which 447 experiments were counterexamples. We can also see that these
counterexamples arise from 89 different programs, and that 4709 experiments were
inconclusive.

### Showing bundled results

This VM includes the databases generated by the authors using Scam-V
that contain the results presented in the paper. These can be found in
`~/scamv/orig_exps` and correspond to the entries in Table 1 and
Figure 7 in the way given by the following mapping:

**TODO** mapping here **TODO**

The script `introduction/scripts/eval_all.py` can be used to
automatically run `db-eval.py` on all the included databases. Results
will be printed out to the terminal in the format described above. The expected output can be found in `introduction/scripts/eval_all_result.txt`.

**NB.** The script `db-eval.py` does not actually exercise the pipeline, it is simply a tool to inspect the results that have already been stored in a database.

## 2. Reproducing experiments

The second step is to generate new experiments with Scam-V using the
same configurations as in the paper.

In order to generate and run experiments with Scam-V, the tool needs a
configuration that specifies parameters such as observation model,
program generator, and number of test cases to generate, among
others. We have included in this VM the same configurations we used in
our experiments, and they are given by the following identifiers:

micro2021_f7_c1_1      Figure 7, column 1, ...
**TODO** mapping **TODO**

Notice that it may happen that the experiment execution process stalls due to run-time issues as indicated in the `EmbExp-Logs` [README file](https://github.com/kth-step/EmbExp-Logs/blob/master/README.md).
In this case many experiments execute without a result, which is indicated with the warning `unsuccessful`.
This requires either to issue a complete restart or, better yet, to cancel the running experiments and resume by manually orchestrating the scripts in [SCAM-V examples](https://github.com/kth-step/HolBA/tree/dev_scamv/src/tools/scamv/examples) or [`EmbExp-Logs`](https://github.com/kth-step/EmbExp-Logs) according to the documentation.
We do not provide a high level script for this purpose.

The process to generate and validate an experiment set is as follows:
1. Select a configuration from the list above (e.g., `micro2021_f7_c1_1`) and execute the following:
   ```
   ./introduction/scripts/2_reproduce_experimentset.sh micro2021_f7_c1_1
   ```
1. Follow the outputs and answer the questions of the script. A second terminal will open up in the process and the first terminal will start running experiment by experiment.
1. It is possible and common practice to monitor the status of the process by opening a third terminal and executing the following from time to time to notice if something goes wrong or the hardware is stuck:
   ```
   ./introduction/scripts/1_status.sh
   ```
1. Wait for the experiments to finish in the first terminal. NOTICE: This step takes about 45 hours for the example invokation shown in step 1. **TODO** Check time estimate
1. Make sure to terminate the board connection in the second terminal once the experiments finished.
1. Check the results using `HolBA_logs/EmbExp-Logs/scripts/db-eval.py 
`. For comments on this, see the last part of the section "Validating a complete experiment set" of the [`EmbExp-Logs`](https://github.com/kth-step/EmbExp-Logs) README document.

**TODO** Add caveat: these are entirely new experiments generated with the same configurations as those in the paper, which means the results will not be exactly the same every time. (Elaborate)

## 3. Custom configurations

**TODO** Do we need this?