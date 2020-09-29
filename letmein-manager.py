#!/usr/bin/python3

from typing import Union
import os
from pathlib import Path
homeDir = str(Path.home())
configPath = os.path.join(homeDir, ".ssh/letmein.config")
keyFile = os.path.join(homeDir, ".ssh/letmein.key")

def writeChanges():
    with open(configPath, "w") as f:
        for entry in entries:
            f.write("|".join(entry) + "\n")

entries = []
with open(configPath, "a+") as f:
    f.seek(0)
    entries = [line.strip().split("|") for line in f]

print("----------------------")
print(":: Entries")
i = 1
for data in entries:
    print(f"{i}. {data[2] + ' - ' if data[2] else ''}{data[0]}@{data[1]}")
    i += 1
print("----------------------")
print(":: Commands")
print("del [id] - delete entry")
print("edit [id] - edit entry")
print("new - add entry")
print("----------------------")
print("Select entry, or enter command")

val = input("> ")
if not val:
    exit()


def validateChoice(val: Union[str, int]):
    try:
        val = int(val)
    except:
        return False
    if val > len(entries):
        return False
    if val == 0: # 0 - 1 == -1 --> last item
        return False
    return val - 1


valSplit = val.split(" ")
choice = valSplit[0]

if choice.isdigit():
    entryID = validateChoice(choice)
    if entryID is False:
        print("Invalid id")
        exit()
    data = entries[entryID]
    os.system(f"ssh {data[1]} -l{data[0]} -i{keyFile}")
if choice == "del":
    if len(valSplit) < 2:
        print("Invalid id")
    entryID = validateChoice(valSplit[1])
    if entryID is False:
        print("Invalid id")
        exit()

    del entries[entryID]
    writeChanges()

elif choice == "edit":
    if len(valSplit) < 2:
        print("Invalid id")
        exit()
    entryID = validateChoice(valSplit[1])
    if entryID is False:
        print("Invalid id")
        exit()
    data = entries[entryID]
    newComment = input(f"Comment [{data[2]}]: ")
    newUsername = input(f"Username [{data[0]}]: ")
    newServer = input(f"Server [{data[1]}]: ")
    newData = [
        newUsername if newUsername else data[0],
        newServer if newServer else data[1],
        newComment if newComment else data[2]
    ]
    entries[entryID] = newData
    writeChanges()

elif choice == "new":
    newComment = input(f"Comment: ")
    newUsername = input(f"Username: ")
    newServer = input(f"Server: ")
    if not newUsername or not newServer:
        print("Username and server are required!")
    
    newData = [
        newUsername,
        newServer,
        newComment if newComment else ""
    ]

    entries.append(newData)
    writeChanges()
