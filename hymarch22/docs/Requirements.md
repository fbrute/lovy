# User Stories for LovySplit

## As a Researcher I want to produce a Simulation Map Synthesis (SMS)

### What is a SMS ?

A **SMS** is produced as a **Map** that synthesizes, a **Simulation**.

## What is a Simulation ?

A Simulation is comprised of a number of Scenarios, contained in an
excel file. Each tab is a Scenario.

## What is a Scenario ?

A _Scenario_ is comprised of a bunch of dates, presented as a column.
For each date  a **BackTrajectory**
is generated
Once generated are computed some basic statitics about
the _gates_ they go through, and drawn as synthesis map
with Qgis. For each _Gate_ we get a single _BackTrajectory_.

### Keywords

* Simulation

* Scenario, for a class, that computes BackTrajectories

* Modes for Simulations, TEST or PROD

* Actions for Scenario, RUN or STAT

* BactTrajectory, computed with Hysplit, provided by ARL.

* Gates
