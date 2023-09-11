###This is used for generating numbers required in slider menus.

print("How many options does your slider have?")
total = int(input())
### Amount of options
value = 1
### Starting Value

incriment = 151 / (total - 1)
### Amount of Pixels / Number of incriments

for x in range(total):
       print(round(value))
       value = value + incriment
