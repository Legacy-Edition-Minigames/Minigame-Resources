from PIL import Image
import numpy as np
import os

##Colors to replace, in RGB
#Target color you want to replace
originalColor = [255, 255, 255]
#Color to replace target with
replaceColor = [224, 220 , 183]

def editimage(imagefile):
    img = Image.open(imagefile)
    img = img.convert("RGBA")

    datas = img.getdata()

    data = np.array(img)   # "data" is a height x width x 4 numpy array
    red, green, blue, alpha = data.T # Temporarily unpack the bands for readability

    #Replace original color with replacement color... (leaves alpha values alone...)
    white_areas = (red == originalColor[0]) & (green == originalColor[1]) & (blue == originalColor[2])
    data[..., :-1][white_areas.T] = (replaceColor) # Transpose back needed

    img = Image.fromarray(data)

    #Save new image
    img.save(imagefile)

##Edit each file in the current directory
for fileList in os.listdir():
    if fileList.endswith(".png"):
        image = ""+str(fileList)
        print("Editing Image: "+image)
        ##Edit the image
        editimage(image)
