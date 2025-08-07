# exiftool() uses cmd line tool 'exiftool' by Phil Harvey - the same tool used to edit the images metadata
# extracts a large amount of metadata in comparison to pilexif() - which uses the PIL python library.

import subprocess
import json

def exiftool():
    file_no = 2
    subprocess.run(["exiftool", "-j","photo%s.jpg"%file_no,">","JSONFILE.json"], shell=True,capture_output=True)

    json_dict = {}

    with open("JSONFILE.json","r") as j:
        exif_dict = json.load(j)
    j.close()

    exif_dict = {str(k):str(v) for k, v in exif_dict[0].items()}

    json_dict["file_"+str(file_no).strip()] = exif_dict

    with open("all_metadata.json","w") as j:
        json.dump(json_dict, j, indent=4)
    j.close()
    for k, v in exif_dict.items():
        print(k, ":", v)


from PIL import Image, ExifTags

def pilexif():
    file_no = 2
    exif_dict = {}
    gps_dict = {}

    img = Image.open("photo2.jpg")
    img_exif = img._getexif()

    try:
        for k, v in img_exif.items():
            metadata = ExifTags.TAGS.get(k,k)
            if metadata == "GPSInfo":
                for t in v:
                    metadata = ExifTags.GPSTAGS.get(t,t)
                    gps_dict[str(metadata)] = str(v[t])
                    # exif_dict[str(metadata)] = str(v[t])
            else:
                exif_dict[str(metadata)] = str(v)
    except KeyError:
        pass
    img.close()

    for k,v in gps_dict.items():
        exif_dict[k] = v
    json_dict = {}
        # starts as an empty {}
    with open("metadata.json","r") as j:
        json_dict = json.load(j)
    j.close()

    # create a nested dict that appends to itself with the new files metadata
    json_dict["file_"+str(file_no).strip()] = exif_dict

    with open("metadata.json","w") as j:
        json.dump(json_dict, j, indent=4)
    j.close()

# pilexif()
exiftool()