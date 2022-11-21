import torch
from torchvision import transforms
from PIL import Image
from models import *

device = 'cuda' if torch.cuda.is_available() else 'cpu'

classes = ('plane', 'car', 'bird', 'cat', 'deer', 'dog', 'frog', 'horse',
           'ship', 'truck')

# Model
print('==> Building model..')
net = SimpleDLA()
net = net.to(device)
if device == 'cuda':
    net = torch.nn.DataParallel(net)

checkpoint = torch.load('ckpt.pth')
net.load_state_dict(checkpoint['net'])

trans = transforms.Compose([
    transforms.Resize((32, 32)),
    transforms.ToTensor(),
])

img = Image.open('picture/plane.png')
img = trans(img)
img = img.unsqueeze(0)

output = net(img)
_, predicted = output.max(1)
pred_class = classes[predicted.item()]
print(pred_class)
