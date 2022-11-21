import torch
from torchvision import transforms
from PIL import Image
from models import *

device = 'cpu'

classes = ('plane', 'car', 'bird', 'cat', 'deer', 'dog', 'frog', 'horse',
           'ship', 'truck')

# Model
print('==> build model ...')
model = torch.load('model.pth')
model = model.to(device)

trans = transforms.Compose([
    transforms.Resize((32, 32)),
    transforms.ToTensor(),
])

img = Image.open('picture/cat.png')
img = trans(img)
img = img.unsqueeze(0)

print('==> inference ...')
output = model(img)
_, predicted = output.max(1)
pred_class = classes[predicted.item()]
print(pred_class)
