import gdal
from PIL import Image
import numpy as np
import os


import scipy.misc as misc

Image.MAX_IMAGE_PIXELS = 1000000000
filename = '../test/zhang.tif'
images  = Image.open(filename).convert('RGB')
images = np.asarray(images, np.uint8)

h, w,_ = images.shape
print(images.shape)


####转换tif------>>>>PNG
dataset = gdal.Open(filename)
im_width = dataset.RasterXSize
im_heigth = dataset.RasterYSize
im_data = dataset.ReadAsArray(0, 0, im_width, im_heigth)
im_redData = im_data[2, :, :]
im_greedData = im_data[1, :, :]
im_blueData = im_data[0, :, :]
data = np.dstack((im_redData, im_greedData, im_blueData))
print(data.shape)
image = np.asarray(data, np.uint8)
print(image)

portion = os.path.split(filename)
result_img = "%s/%s.png" % (portion[0], portion[1].split(".")[0])

misc.imsave(result_img, data)

