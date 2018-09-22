# -*- coding: utf-8 -*-
"""
Created on Mon Feb 01 18:19:16 2016

@author: Svv Satyanarayana
"""

# -*- coding: utf-8 -*-
"""
Created on Sat Jan 30 09:21:15 2016

@author: Svv Satyanarayana
"""

import cv2
#import numpy as np
face_cascade =cv2.CascadeClassifier('haarcascade_frontalface_alt.xml')
face_mask = cv2.imread('face.jpg')
#height and weight
h_mask, w_mask = face_mask.shape[:2]
if face_cascade.empty():
 raise IOError('Unable to load the face cascade classifier xml file')
cap = cv2.VideoCapture(0)
scaling_factor = 0.7
while True:
 ret, frame = cap.read()
 frame = cv2.resize(frame, None, fx=scaling_factor, fy=scaling_factor)
 gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
 face_rects = face_cascade.detectMultiScale(gray, 1.3, 5)
 for (x,y,w,h) in face_rects:
  if h > 0 and w > 0:
# Adjust the height and weight parameters depending on the
#sizes and the locations. 
   h, w = int(1.2*h), int(1.2*w)
   x-=0.09*h
   y -= 0.1*h
# Extract the region of interest from the image
  frame_roi = frame[y:y+h, x:x+w]
  face_mask_small = cv2.resize(face_mask, (w, h),
  interpolation=cv2.INTER_AREA)
# Convert color image to grayscale and threshold it
  gray_mask = cv2.cvtColor(face_mask_small, cv2.COLOR_BGR2GRAY)
  ret, mask = cv2.threshold(gray_mask, 180, 255,
  cv2.THRESH_BINARY_INV)
# Create an inverse mask
  mask_inv = cv2.bitwise_not(mask)
# Use the mask to extract the face mask region of interest
  masked_face = cv2.bitwise_and(face_mask_small, face_mask_small,mask=mask)
# Use the inverse mask to get the remaining part of the image
  masked_frame = cv2.bitwise_and(frame_roi, frame_roi,mask=mask_inv)
# add the two images to get the final output
  frame[y:y+h, x:x+w] = cv2.add(masked_face, masked_frame)
  cv2.imshow('Face Detector', frame)
  cv2.imwrite('photo.jpg',frame)
  c = cv2.waitKey(1)
  if c == 27:
    break
 
cap.release()
cv2.destroyAllWindows()