SketchyCOCO dataset

This repository hosts the ShetchyCOCO dataset. Please refer to our CVPR paper for more information: ["SketchyCOCO: Image Generation from Freehand Scene Sketches"](https://arxiv.org/abs/2003.02683).

SketchyCOCO dataset can be explored by https://sysu-imsl.com/EdgeGAN/dataset.html or https://sysu-imsl.github.io/EdgeGAN/dataset.html.

## Overview

+ [Dataset](#1)
+ [Dataset Augmentation](#6)
+ [Captions of the file structure in the dataset](#2)
+ [Google Drive Hosting](#3)
+ [Baidu Netdisk Hosting](#7)
+ [Optional](#4)
+ [Licensing](#5)

<h2 id="1">Dataset</h2>

SketchyCOCO dataset consists of two part:

+ Object-level data
  + Object-level data contains $20198(train18869+val1329)$ triplets of \{foreground sketch, foreground image, foreground edge map\} examples covering 14 classes, $27683(train22171+val5512)$ pairs of \{background sketch, background image\} examples covering 3 classes. 
+ Scene-level data
  + Scene-level data contains $14081(train 11265 + val 2816)$ pairs of \{foreground image\&background sketch, scene image\} examples, $14081(train 11265 + val 2816)$  pairs of  \{scene sketch, scene image\} examples and the  segmentation ground truth for $14081(train 11265 + val 2816)$ scene sketches. Some val scene images come from the train images of the COCO-Stuff dataset for increasing the number of the val images of the SketchyCOCO dataset.

<h2 id="6">Dataset Augmentaion</h2>

We increase 4662 images for 9 objects, their correspondence edge maps and sketches. The details of dataset augmentation is shown below. And the augmentation has been merged into Object-level data.

| cat  | dog  | zebra | giraffe | horse | cow  | elephant | sheep | Car  |
| ---- | ---- | ----- | ------- | :---- | ---- | -------- | ----- | ---- |
| 659  | 777  | 401   | 246     | 773   | 628  | 398      | 369   | 411  |

<h2 id="2">Captions of the file structure in the dataset</h2>

+ data
  + Scene - Scene-level data
    + GT - Ground Truth
      + trainInTrain - Train images of SketchyCOCO dataset from the train images of the COCO-Stuff dataset
      + valInTrain - Val images of SketchyCOCO dataset from the train images of the COCO-Stuff dataset
      + val - Val images of SketchyCOCO dataset from the val images of the COCO-Stuff dataset
    + Sketch - Sketch scene of GT (a sketch scene has the same name with the corresponding GT)
    + Annotation - Annotations for sketch scene segmentation
  + Object - Object-level data
    + GT - Ground Truth
    + Sketch - Sketch image of the GT (a edge image has the same name with the corresponding GT)
    + Edge - Edge image of the GT (a edge image has the same name with the corresponding GT)
  + Others - Intermediate products when building the dataset
    + background - Background images and sketches
    + background_training - Images of {foreground image&background sketch} data
    + foreground - Foreground images and sketches used in the scene
    + intermediate product - Images of {generated image&background sketch} data
    + sketches_background - Sketches for building the background sketches
  + Image Source - Files storing the source of images
+ matlab_code - Codes for building the dataset

<h2 id="3">Google Drive Hosting</h2>

+ [Object-level data](https://drive.google.com/file/d/1P2kb1SCqnZrK_P32Vmcf5FShjbC9kN7e/view?usp=sharing)
+ [Scene-level data](https://drive.google.com/file/d/1ApjDhGjtqfFEMzm6dmyhS-2aXnnYLxnj/view?usp=sharing)
+ [Others](https://drive.google.com/file/d/1JxTmgLOM8P-3U2kNzTFP6fm2TS-ZAnPT/view?usp=sharing)
+ [Image Source](https://drive.google.com/file/d/1qVw0jp0dpLPeJw70s6sLNU2RSd-E3E5k/view?usp=sharing)

<h2 id="7">Baidu Netdisk Hosting</h2>

+ [Object-level data](https://pan.baidu.com/s/1jO0GyWwonamduc6Umo5X_g)  Password:nv6n
+ [Scene-level data A](https://pan.baidu.com/s/1udiN_nbBUarB1DChytR7SQ)  Password:7k48
+ [Scene-level data B](https://pan.baidu.com/s/1EZZT6eWsfliCv1x5-EwWWw)  Password:l43w
+ [Scene-level data C](https://pan.baidu.com/s/1b6jlnDMGD0kC6jsAuO0zxw)  Password:3umq
+ [Others](链接:https://pan.baidu.com/s/1KH5ZvRp7_LixP0LARC5_5g)  Password:4hy0
+ [Image Source](https://pan.baidu.com/s/1tD3LE7oDhKQSGi53GRW1-Q)  Password:vrem

PS: Merge trainInTrain_part of Scene-level data B and data C into  GT/trainInTrain of Scene-level data A after downloading.

<h2 id="4">Optional</h2>

+ You can build a new dataset using the following instructions:

  1. Install [COCO API](https://github.com/nightrome/cocostuffapi) for Matlab.

  2. Download images and annotations of [the COCO-Stuff dataset](https://github.com/nightrome/cocostuff).

  3. Run ./matlab_code/constructDataset.m after changing the parameters in the code.

+ The XDoG image can be obtained by running ./matlab_code/XDoG.m after changing the parameters in the code.

+ The pairs of the objects can be obtained by running ./matlab_code/preprocess_combine.m after changing the parameters in the code.

+ The pairs of the scenes can be obtained by running ./matlab_code/combineScript.m after changing the parameters in the code.

<h2 id="5">Licensing</h2>
SketchyCOCO is a derivative work of [the Sketchy Database](http://sketchy.eye.gatech.edu/), [the COCO-Stuff Dataset](https://github.com/nightrome/cocostuff), [TU Berlin](http://cybertron.cg.tu-berlin.de/eitz/projects/classifysketch/), [Car Dataset](http://ai.stanford.edu/~jkrause/cars/car_dataset.html), [cats_vs_dogs](https://tensorflow.google.cn/datasets/catalog/cats_vs_dogs?hl=zh-cn) and [Pascal voc 2012](http://host.robots.ox.ac.uk/pascal/VOC/). The authors of the COCO-Stuff database, the Sketchy Database, TU Berlin, Car Dataset, cats_vs_dogs and Pascal voc 2012 do not in any form endorse this work. Different licenses apply:

+ Images: [Flicker Terms of use](https://info.yahoo.com/legal/us/yahoo/utos/utos-173.html)
+ Sketches: [Creative Commons Attribution 4.0 License](http://cocodataset.org/#termsofuse)
+ SketchyCOCO code: [Creative Commons Attribution 4.0 License](http://cocodataset.org/#termsofuse)

