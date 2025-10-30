## 8-Bit-Forensics 💾
_A Digital Forensics Educational Game_ <br>

<img width="960" height="1080" alt="NPC Game Guide" src="https://github.com/user-attachments/assets/95eb0e8e-8944-4889-baba-9a42454a7e8c" />

## Features 🧪
Typical digital forensic software functionalities were created, acting as the core concepts of the game. <br>
Allowing players to carry out realistic forensic tasks commonly performed within real investigations. <br>
The art is kept light-hearted and simplistic to allow for a wide range of individuals to play.

Using a dialogue-based, story-driven gameplay to educate the players on typical digital forensic investigative processes such as:
- Bagging and unbagging evidence
- Filling out the chain of custody form, emphasising its importance
- Producing a forensic image file from the physical evidence collected
- Verifying file integrity using hash algorithms; MD5, SHA1, SHA256, SHA512
- Hex Viewer functionalities; searching for file signatures, as well as selecting and saving blocks to manually carve image files
- Analysing metadata from files extracted using the hex-viewing capabilities
- End of level quizzes, used to reiterate important information learnt
<img width="480" height="1080" alt="Evidence Bag" src="https://github.com/user-attachments/assets/1f1a3bbd-6c91-48cf-8335-51d66d9a7293" />
<img width="480" height="1080" alt="Forensic Image File" src="https://github.com/user-attachments/assets/fd52e1f6-839b-4671-baa3-d8aa7075facc" />
<img width="480" height="1080" alt="Hex Viewer" src="https://github.com/user-attachments/assets/2796040d-08e6-457b-a677-af3c7acba76a" />
<img width="480" height="1080" alt="Desk" src="https://github.com/user-attachments/assets/2bd0265f-32a4-4632-90d6-6d106669ff3a" />


## Tech Stack 📂
- **Godot Engine** - Game engine; GDScript
- **Python** - To handle the metadata extraction from files, writing to a JSON file
- **Batch File** - Manage the external script execution and cleanup
- **Command Line Tools** - Built-in Windows functionality to perform the hash verification
- **Aesprite** - Used to create the art assets

## Installation 🥼
### Option 1
- Install most recent release: - https://github.com/amy-ev/8-Bit-Forensics/releases <br>

### Option 2
**Prerequisites:**
Godot 4.4+ <br>
&ensp; &ensp; &ensp; &ensp; &ensp; &ensp; &ensp;&ensp;&ensp;  Python 3.13.3

- Clone the repository <br>
```
git clone https://github.com/amy-ev/8-Bit-Forensics.git
```
## Usage 🔎
- Launch the Godot Engine
- Click 'Import'
- Navigate to the game folder
- Select the `project.godot` file and click 'Open'
- Select 'Import' with 'Edit Now' unchecked
- Run the project

_Shift+F11 can be used to fullscreen the game_ <br>

_Follow the in-game instructions and prompts to interact with the evidence, analyse image files and carry out a light-hearted digital forensics investigation_
