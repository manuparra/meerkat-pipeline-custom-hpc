<p align="center">
   <img src="https://raw.githubusercontent.com/idia-pipelines/idia-pipelines.github.io/master/assets/idia_logo.jpg" alt="IDIA pipelines"/>
</p>

# The IDIA MeerKAT Pipeline

The IDIA MeerKAT pipeline is a radio interferometric calibration pipeline designed to process MeerKAT data. **It is under heavy development, and so far only implements the cross-calibration steps, and quick-look images. Please report any issues you find in the [GitHub issues](https://github.com/idia-astro/pipelines/issues).**

## Requirements

This pipeline is designed to run on the Ilifu cluster, making use of SLURM and MPICASA. For other uses, please contact the authors. Currently, use of the pipeline requires access to the Ilifu cloud infrastructure. You can request access using the following [form](http://docs.ilifu.ac.za/#/getting_started/request_access).

## Quick Start

### 1. In order to use the `processMeerKAT.py` script, source the `setup.sh` file:

        source /idia/software/pipelines/master/setup.sh

which will add the correct paths to your `$PATH` and `$PYTHONPATH` in order to correctly use the pipeline. We recommend you add this to your `~/.profile`, for future use.

### 2. Build a config file:

        processMeerKAT.py -B -C myconfig.txt -M mydata.ms

This defines several variables that are read by the pipeline while calibrating the data, as well as requesting resources on the cluster. The config file parameters are described by in-line comments in the config file itself wherever possible.

a. For continuum/spectral line processing :

    processMeerKAT.py -B -C myconfig.txt -M mydata.ms

b. For polarization processing :

    processMeerKAT.py -B -C myconfig.txt -M mydata.ms -P

c. Including self-calibration :

    processMeerKAT.py -B -C myconfig.txt -M mydata.ms -2

d. Including science imaging :

    processMeerKAT.py -B -C myconfig.txt -M mydata.ms -I


### 3. To run the pipeline:

        processMeerKAT.py -R -C myconfig.txt

This will create `submit_pipeline.sh`, which you can then run with `./submit_pipeline.sh` to submit all pipeline jobs to the SLURM queue.

Other convenient scripts are also created that allow you to monitor and (if necessary) kill the jobs. `summary.sh` provides a brief overview of the status of the jobs in the pipeline, `findErrors.sh` checks the log files for commonly reported errors, and `killJobs.sh` kills all the jobs from the current run of the pipeline, ignoring any other jobs you might have running.

For help, run `processMeerKAT.py -h`, which provides a brief description of all the command line arguments.

## Selecting an HPC facility to run the pipeline on

As of V2.X of the processMeerKAT pipeline, adaptations have been made to allow users to more easily run the pipeline on the SLURM based HPC facility of their choice.
As a default, the pipeline will build and execute as if on the ilifu cluster.

To build the pipeline for your own cluster you have to do two things:
1. Add an appropriatly named section to [known_hpc.cfg](./known_hpc.cfg).
1. Use the `--hpc` command line argument with your facilities name when building and running your pipeline, e.g. `--hpc ilifu`.

Not all values within the config need to be re-written or changed for the facilities section. If you do not include an entry in your section, the value will default to that of the `DEFAULT` section.

By putting in a name which does not point to a section in the [known_hpc.cfg](./known_hpc.cfg) file, the pipeline will revert to the values in the `UNKNOWN` section. This sets the upper limits of your configured HPC to extreme values, which are likely to cause the pipeline to fail, unless explicitly set using the respective the command line arguments.

## Using multiple spectral windows (new in V1.1)

Starting with V1.1 of the processMeerKAT pipeline, the default behaviour is to split up the MeerKAT band into 16 spectral windows (SPWs), and process each concurrently. This results in a few major usability changes as outlined below:

1. **Calibration output** : Since the calibration is performed independently per SPW, all the output specific to that SPW is within it's own directory. Output such as the calibration tables, logs, plots etc. per SPW can be found within each SPW directory.

2. **Logs in the top level directory** : Logs in the top level directory (*i.e.,* the directory where the pipeline was launched) correspond to the scripts in the `precal_scripts` and `postcal_scripts` variables in the config file. These scripts are run from the top level before and after calibration respectively. By default these correspond to the scripts to calculate the reference antenna (if enabled), partition the data into SPWs, and concat the individual SPWs back into a single MS/MMS.

More detailed information about SPW splitting is found [here](/docs/processMeerKAT/using-the-pipeline#spw-splitting).

The documentation can be accessed on the [pipelines website](https://idia-pipelines.github.io/docs/processMeerKAT), or on the [Github wiki](https://github.com/idia-astro/pipelines/wiki).
