from torch import nn as nn
import torch
from torch.nn import functional as F
from torchvision.transforms import ToTensor
from torchvision.utils import save_image
import numpy as np
import os, sys, cv2


# Import files from the local folder
root_path = os.path.abspath('.')
sys.path.append(root_path)
from opt import opt
from model.weight_utils import check_weight_path
from model.RealCuGAN.cunet import UNet_Full



class RealCuGAN_upscaler(object):
    
    def __init__(self, scale, weight_path = "pretrained/2x_RealCuGAN.pth"):
        
        # Load the model here
        self.model = UNet_Full(scale)
        
        # Read and Clean the weight
        check_weight_path(weight_path, "Real-CuGAN")
        checkpoint_g = torch.load(weight_path)
        if "pro" in checkpoint_g:
            # We need to delete "pro" part in cunet (Real-CUGAN)
            del checkpoint_g["pro"]
        
        # Load the weight
        self.model.load_state_dict(checkpoint_g)
        self.model = self.model.eval().cuda()
        
        # Other setting
        self.model_name = "Real-CuGAN"
    
    

    def __call__(self, input_path, store_path):
        ''' Super-Resolve the image with input_path
        Args:
            input_path (str):   The input path 
            store_path (str):   The store path
        '''
        
        # Read image and Transform
        img_lr = cv2.imread(input_path)
        img_lr = cv2.cvtColor(img_lr, cv2.COLOR_BGR2RGB)
        img_lr = ToTensor()(img_lr).unsqueeze(0).cuda()     # Use tensor format
        
        
        # Inference
        gen_hr = self.model(img_lr)
        
        
        # Store the generated image
        save_image(gen_hr, store_path) 
        
        # Empty the cache every time you finish processing one image
        torch.cuda.empty_cache() 