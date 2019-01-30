# P4Runtime API Controller Synthesis Using FRP

For a description of the proposed research, see: [Research Proposal](https://docs.google.com/document/d/13UhfMzuLgHZB24gnmlTV_pRGYQKHTlvJs-0mtDDsrgI/edit?usp=sharing).

The goal of this research is to combine two seperate research directions taken by members of Ruzica Piskac's research group. The first involves the [synthesis of functional reactive programs](https://arxiv.org/abs/1712.00246) and the second utilizes automated repair by example applied to [firewalls](http://www.cs.yale.edu/homes/zhai-ennan/firemason.pdf).

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them:

Install [BoSy](https://github.com/reactive-systems/bosy) and follow the instructions given in its Readme. 
To play around with BoSy, there's a helpful tool: https://www.react.uni-saarland.de/tools/online/BoSy/
For more information, see this paper: https://www.react.uni-saarland.de/publications/cav2017-bosy.pdf
Bosy is a tool required for synthesis. However, once it's installed, there is a wrapper shell script that needs to be placed in BoSy/* in order for later tslsynthesis tools to work. 
```
wrapper.sh:

#!/bin/bash
pushd .
cd ~/BoSy
~/BoSy/.build/release/BoSy --synthesize --target aiger $1
```

#### Gain access to the mercurial repositories:

In order to access all the synthesis tools, you must first get access to the repository server: https://version.react.uni-saarland.de/_admin/register. 
```
The following repositories are necessary:
  aigerlib
  tsltools
  finitelib
  tslbenchmarks
```

#### P4 Development & Utilizing P4Runtime/PI

The P4 Runtime API is a silicon-independent and protocol-independent API. In order to develop with it, you need mininet, grpc, and multitudes of dependencies. If you are running a native Linux build, the dependencies can be installed by hand using two shell scripts found in [tutorials](https://github.com/p4lang/tutorials/). Otherwise, you'll still need to use [tutorials](https://github.com/p4lang/tutorials/) to install a VM. 

To build the virtual machine:
- Install [Vagrant](https://vagrantup.com) and [VirtualBox](https://virtualbox.org)
- `cd vm`
- `vagrant up`
- Log in with username `p4` and password `p4` and issue the command `sudo shutdown -r now`
- When the machine reboots, you should have a graphical desktop machine with the required
software pre-installed.

To install dependencies by hand, please reference the [vm](../vm) installation scripts.
They contain the dependencies, versions, and installation procedure.
You can run them directly on an Ubuntu 16.04 machine:
- `sudo ./root-bootstrap.sh`
- `sudo ./user-bootstrap.sh`

### Installing

Once you have the local dependencies or the vm installed, clone the following repository: https://github.com/vvkgopalan/7-15-2018
This repository has two controllers that utilize the P4Runtime API. Under testing, there are two example controllers. 

## Running the tests

1. In your shell, run:
   ```bash
   make
   ```
   This will:
   * compile `p4program.p4`,
   * start a Mininet instance with n switches based on `topology.json`

2. You should now see a Mininet command prompt. Start a ping between h1 and h2:
   ```bash
   mininet> h1 ping h2
   ```
   Based on the controller, there will be different interactions. 
   
3. Open another shell and run the starter code:
   ```bash
   ./main.py
   ```
   This will install the `p4program.p4` program on the switches and push the
   forwarding rules.

4. Press `Ctrl-C` to the second shell to stop `main.py`

## Acknowledgments

* Mark Santolucito, Bill Hallahan, Ruzica Piskac for all the help and guidance. There is a lot of work still to do on this project as synthesis still has yet to be completed. 
* A summary of the summer's work can be found [here](https://docs.google.com/document/d/1PATTYmEoPL06X4Y1BA2ra9zLtxsPLkJ9g4fwv1ae0n0/edit?usp=sharing).
