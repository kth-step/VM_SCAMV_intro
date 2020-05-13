# SCAM-V (Validation of Abstract Side-Channel Models for Computer Architectures)
In our paper, we describe a method to generate test inputs to validate side-channel models.
The implementation thereof is called SCAM-V and consists of a test input generation tool and a number of models together with a hardware benchmark platform.
The tool has been packaged in this VM together with our evaluation results.
However, the actual evaluation of the tool generated test inputs requires a benchmark platform, which can be built with a bit of special hardware according to the documentation in the repository we have made available through the GitHub project [EmbExp-Box](https://github.com/kth-step/EmbExp-Box).

In order to simplify the evaluation process, we have given access to our benchmark platform for this VM.
This way, an evaluator is able to generate test inputs and execute them on the actual hardware benchmark platform remotely without requiring to invest in building an experiment setup first.
The Artifact Evaluation Chairs have agreed to this practice in an email.
Note that the process of executing test cases remotely requires internet access for the VM and the possibility to establish an SSH connection to `tcs79.csc.kth.se` on port `4422`.
The alternative is to build a local [`EmbExp-Box`](https://github.com/kth-step/EmbExp-Box) instance with a Raspberry Pi 3 board interfaced with appropriate JTAG and UART connections.

The evaluators may need to coordinate their efforts because whole experiment sets take long to execute and the hardware resources in our benchmark platform are limited.
We currently only have 4 instances of Raspberry Pi 3 available and one of us may also use one instance during the evaluation process.
Furthermore, be aware that the hardware sometimes exhibits hardware issues as mentioned in the [`EmbExp-Logs`](https://github.com/kth-step/EmbExp-Logs) README document, in the end of section "Validating experiments and cache inspection".



## 1. The results presented in the paper
The first step is to review the results presented in this paper.
These are the result of generating test inputs, or experiments, using the tool SCAM-V and the execution of these experiments on our benchmark platform.
In this section, we reexecute already generated test inputs, which validates our classification of counterexamples for the experiment sets presented in the paper.

### Experiment sets
When SCAM-V generates test cases, it stores them in a custom directory structure we call `EmbExp-Logs`, or just logs.
At first, they are experiments that have not been executed yet.
After executing them on a board, their outputs are stored in the logs and they are ready for evaluation.
For convenient handling, the logs are a git repository that is prepared with scripts to execute and evaluate the results of executions.
This git repository resides in `HolBA_logs/EmbExp-Logs` and more detailed information about how to use the scripts are in the GitHub project [EmbExp-Logs](https://github.com/kth-step/EmbExp-Logs).
The scripts reside in the directory "scripts" and all of them provide basic usage information if executed with the command line switch "--help".
Each bash terminal in the VM always has the HolBA environment loaded.

Each column of the tables 1-4 in the paper is rendered from an experiment set, which in turn is contained in a branch of the logs repository.
This is the mapping of paper results to logs repository branches:
```
Table 1. Cache set index only
Monadic             > cav_19_12_03_qc_xld_len4_indexonly
Random              > cav_20-01-26_rand_wo_both_indexonly


Table 2. Partitioned cache
Unaligned           > cav_19_12_03_prefetch_enum_cpart
Aligned             > cav_19_12_03_prefetch_enum_cpart_aligned


Table 3. Cache tag and set index
Random              > cav_20-01-22_rand_wo_both
Monadic load        > cav_19_12_03_qc_xld
Monadic previction  > cav_19_12_03_qc_previct5


Table 4. Cache tag and set index (faulty observational models)
Random              > cav_20-01-23_rand_plain_mod
```

### Validating the experiment sets
The whole process of validating individual experiments and whole sets is described in the [`EmbExp-Logs`](https://github.com/kth-step/EmbExp-Logs) README document.
In order to simplify this process, we provide a script in this VM to support high level operation and ease the introduction to SCAM-V.

Notice that it may happen that the experiment execution process stalls due to run-time issues as indicated in the `EmbExp-Logs` [README file](https://github.com/kth-step/EmbExp-Logs/blob/master/README.md).
In this case many experiments execute without a result, which is indicated with the warning `unsuccessful`.
This requires either to issue a complete restart or, better yet, to cancel the running experiments and resume by manually orchestrating the scripts in [SCAM-V examples](https://github.com/kth-step/HolBA/tree/dev_scamv/src/tools/scamv/examples) or [`EmbExp-Logs`](https://github.com/kth-step/EmbExp-Logs) according to the documentation.
We do not provide a high level script for this purpose.

The process to validate an experiment set is as follows:
1. Select a branch from the list above (e.g., `cav_19_12_03_qc_xld_len4_indexonly`) and execute the following:
   ```
   ./introduction/scripts/1_validate_branch.sh cav_19_12_03_qc_xld_len4_indexonly
   ```
1. Follow the outputs and answer the questions of the script. A second terminal will open up in the process and the first terminal will start running experiment by experiment.
1. It is possible and common practice to monitor the status of the process by opening a third terminal and executing the following from time to time to notice if something goes wrong or the hardware is stuck:
   ```
   ./introduction/scripts/0_status.sh
   ```
1. Wait for the experiments to finish in the first terminal. NOTICE: This step takes about 45 hours for the example invokation shown in step 1.
1. Make sure to terminate the board connection in the second terminal once the experiments finished.
1. Check the results using `git diff`. For comments on this, see the last part of the section "Validating a complete experiment set" of the [`EmbExp-Logs`](https://github.com/kth-step/EmbExp-Logs) README document.



## 2. Reproducing results
The second step is to apply the whole SCAM-V toolchain to reproduce the results from generating test inputs up to evaluating the results of their executions.
Therefore, we introduce the scripts to facilitate reproduction of the paper results in the following sections.
These scripts are using existing SCAM-V tool scripts, which reside in the [SCAM-V examples](https://github.com/kth-step/HolBA/tree/dev_scamv/src/tools/scamv/examples) directory and are roughly described in the README document that is located there.

Reproducing results is based on the configuration files in the directory `HolBA/src/tools/scamv/examples/expgenruns`, where the filenames correspond to the suffixes of the branch names we have seen in the sections before.
These configuration files have been used to produce the branches of the repository `HolBA_logs/EmbExp-Logs`.
With the example branch `cav_19_12_03_qc_xld_len4_indexonly`, the suffix is `qc_xld_len4_indexonly` and the corresponding configuration file is `qc_xld_len4_indexonly.txt`.
In these files only the first line is relevant, the rest are comments.
The parameters in this first line are directly interpreted by SCAM-V in the HolBA environment.

The experiment execution process may stall due to various run-time effects like described in the previous section (with infinite `unsuccessful` warnings).
In this case a complete restart or a manual cancel and resume operation is required.

The process to reproduce the results includes generation of new test cases, executing these test cases, and evaluating the results. The steps are as follows:
1. Select a branch from the list above (e.g., `cav_19_12_03_qc_xld_len4_indexonly`), extract the configuration id (e.g., `qc_xld_len4_indexonly`) and execute the following:
   ```
   ./introduction/scripts/2_reproduce_experimentset.sh qc_xld_len4_indexonly
   ```
1. Follow the outputs and answer the questions of the script. Two more terminals will open up in the process and the first terminal will start running experiment by experiment.
1. It is possible and common practice to monitor the status of the process by opening a third terminal and executing the following from time to time to notice if something goes wrong or the hardware is stuck:
   ```
   ./introduction/scripts/0_status.sh
   ```
1. Wait for the experiments to finish in the first terminal. NOTICE: This step takes about 45 hours for the example invokation shown in step 1.
1. Make sure to terminate the board connection in one of the secondary terminals once the experiments finished.
1. Get an overview of the results using the status monitor script we used before.
1. Inspect the results according to the documentation in [`EmbExp-Logs`](https://github.com/kth-step/EmbExp-Logs) to understand the counterexamples that have been found.



## 3. Extendability to new problem spaces
Finally, one may want to extend SCAM-V for new observational models, attacker models, or hardware types.

The relevant places for adding new or modifying existing observational models are described in the [SCAM-V](https://github.com/kth-step/HolBA/tree/dev_scamv/src/tools/scamv) documentation.
For new attacker models, the code of [`EmbExp-ProgPlatform`](https://github.com/kth-step/EmbExp-ProgPlatform) needs to be reviewed and extended.
Additionally, new command line switches need to be added to SCAM-V.

Adding new hardware may require integration of a new ISA model into HolBA as well as porting or adding the desired observational model in SCAM-V.
Additionally, new command line switches may be required for SCAM-V.
If the intended hardware is not yet integrated in `EmbExp-ProgPlatform` and [`EmbExp-Box`](https://github.com/kth-step/EmbExp-Box), these repositories require respective additions as well.
Their documentation, code and commit history may be consulted for this purpose.

