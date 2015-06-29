![Vote](https://raw.githubusercontent.com/seansellek/Vote/master/images/vote_banner.jpg)
Vote parses population and poll results from json files and calculates results, allowing you to compare electoral vs. popular outcomes. Ultimately, the goal is for Vote to automatically pull the latest poll data from polling apis during a race. It is in very early stages, and can break in a million ways if you don't follow the instructions carefully. =)

##Instructions
1. Import state-by-state population data from json file: `import census [filepath]`. For convenience, omitting the filepath imports data from the 2010 census, which will be used in all elections through 2020. Optionally, enter `list` to verify information successfully imported and see the electoral votes for each state as calculated.
2. Import state-by-state polls from json file: `import poll [filepath]`. Omitting the filepath imports the last poll data from 2012 presidential race.
3. Once all necessary data is imported, enter `run` to display electoral and popular results for the race if the polls hold true.

##To-Do
* Colorize & improve formatting of results output.
* Improve help text & general ux
* Allow user to tweak poll results by state to calculate outcomes
* Implement direct data import from Pollster polling apis

####TL;DR
`import` then `run`
