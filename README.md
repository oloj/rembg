# Rembg

[![Downloads](https://pepy.tech/badge/rembg)](https://pepy.tech/project/rembg)
[![Downloads](https://pepy.tech/badge/rembg/month)](https://pepy.tech/project/rembg)
[![Downloads](https://pepy.tech/badge/rembg/week)](https://pepy.tech/project/rembg)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://img.shields.io/badge/License-MIT-blue.svg)
[![Hugging Face Spaces](https://img.shields.io/badge/🤗%20Hugging%20Face-Spaces-blue)](https://huggingface.co/spaces/KenjieDec/RemBG)
[![Streamlit App](https://img.shields.io/badge/🎈%20Streamlit%20Community-Cloud-blue)](https://bgremoval.streamlit.app/)


Rembg is a tool to remove images background.

<p style="display: flex;align-items: center;justify-content: center;">
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/car-1.jpg" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/car-1.out.png" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/car-2.jpg" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/car-2.out.png" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/car-3.jpg" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/car-3.out.png" width="100" />
</p>

<p style="display: flex;align-items: center;justify-content: center;">
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/animal-1.jpg" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/animal-1.out.png" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/animal-2.jpg" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/animal-2.out.png" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/animal-3.jpg" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/animal-3.out.png" width="100" />
</p>

<p style="display: flex;align-items: center;justify-content: center;">
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/girl-1.jpg" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/girl-1.out.png" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/girl-2.jpg" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/girl-2.out.png" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/girl-3.jpg" width="100" />
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/examples/girl-3.out.png" width="100" />
</p>


## Requirements

```
python: >3.7, <3.11
```

## Installation

CPU support:

```bash
pip install rembg
```

GPU support:

First of all, you need to check if your system supports the `onnxruntime-gpu`.

Go to https://onnxruntime.ai and check the installation matrix.

<p style="display: flex;align-items: center;justify-content: center;">
  <img src="https://raw.githubusercontent.com/danielgatis/rembg/master/onnxruntime-installation-matrix.png" width="400" />
</p>

If yes, just run:

```bash
pip install rembg[gpu]
```

## Usage as a cli

After the installation step you can use rembg just typing `rembg` in your terminal window.

The `rembg` command has 3 subcommands, one for each input type:
- `i` for files
- `p` for folders
- `s` for http server

You can get help about the main command using:

```
rembg --help
```

As well, about all the subcommands using:

```
rembg <COMMAND> --help
```

### rembg `i`

Used when input and output are files.

Remove the background from a remote image

```
curl -s http://input.png | rembg i > output.png
```

Remove the background from a local file

```
rembg i path/to/input.png path/to/output.png
```

Remove the background specifying a model

```
rembg i -m u2netp path/to/input.png path/to/output.png
```

Remove the background returning only the mask

```
rembg i -om path/to/input.png path/to/output.png
```


Remove the background applying an alpha matting

```
rembg i -a path/to/input.png path/to/output.png
```

### rembg `p`

Used when input and output are folders.

Remove the background from all images in a folder

```
rembg p path/to/input path/to/output
```

Same as before, but watching for new/changed files to process

```
rembg p -w path/to/input path/to/output
```

### rembg `s`

Used to start http server.

To see the complete endpoints documentation, go to: `http://localhost:5000/docs`.

Remove the background from an image url

```
curl -s "http://localhost:5000/?url=http://input.png" -o output.png
```

Remove the background from an uploaded image

```
curl -s -F file=@/path/to/input.jpg "http://localhost:5000"  -o output.png
```

## Usage as a library

Input and output as bytes

```python
from rembg import remove

input_path = 'input.png'
output_path = 'output.png'

with open(input_path, 'rb') as i:
    with open(output_path, 'wb') as o:
        input = i.read()
        output = remove(input)
        o.write(output)
```

Input and output as a PIL image

```python
from rembg import remove
from PIL import Image

input_path = 'input.png'
output_path = 'output.png'

input = Image.open(input_path)
output = remove(input)
output.save(output_path)
```

Input and output as a numpy array

```python
from rembg import remove
import cv2

input_path = 'input.png'
output_path = 'output.png'

input = cv2.imread(input_path)
output = remove(input)
cv2.imwrite(output_path, output)
```

How to iterate over files in a performatic way

```python
from pathlib import Path
from rembg import remove, new_session

session = new_session()

for file in Path('path/to/folder').glob('*.png'):
    input_path = str(file)
    output_path = str(file.parent / (file.stem + ".out.png"))

    with open(input_path, 'rb') as i:
        with open(output_path, 'wb') as o:
            input = i.read()
            output = remove(input, session=session)
            o.write(output)
```

## Usage as a docker

Just replace the `rembg` command for `docker run danielgatis/rembg`.

Try this:

```
docker run danielgatis/rembg i path/to/input.png path/to/output.png
```

## Models

All models are downloaded and saved in the user home folder in the `.u2net` directory.

The available models are:

-   u2net ([download](https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net.onnx), [source](https://github.com/xuebinqin/U-2-Net)): A pre-trained model for general use cases.
-   u2netp ([download](https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2netp.onnx), [source](https://github.com/xuebinqin/U-2-Net)): A lightweight version of u2net model.
-   u2net_human_seg ([download](https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net_human_seg.onnx), [source](https://github.com/xuebinqin/U-2-Net)): A pre-trained model for human segmentation.
-   u2net_cloth_seg ([download](https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net_cloth_seg.onnx), [source](https://github.com/levindabhi/cloth-segmentation)): A pre-trained model for Cloths Parsing from human portrait. Here clothes are parsed into 3 category: Upper body, Lower body and Full body.
-   silueta ([download](https://github.com/danielgatis/rembg/releases/download/v0.0.0/silueta.onnx), [source](https://github.com/xuebinqin/U-2-Net/issues/295)): Same as u2net but the size is reduced to 43Mb.
-   isnet-general-use ([download](https://github.com/danielgatis/rembg/releases/download/v0.0.0/isnet-general-use.onnx), [source](https://github.com/xuebinqin/DIS)): A new pre-trained model for general use cases.

### Some differences between the models result

<table>
    <tr>
        <th>original</th>
        <th>u2net</th>
        <th>u2netp</th>
        <th>u2net_human_seg</th>
        <th>u2net_cloth_seg</th>
        <th>silueta</th>
        <th>isnet-general-use</th>
    </tr>
    <tr>
        <th><img src="https://raw.githubusercontent.com/danielgatis/rembg/master/tests/fixtures/car-1.jpg" width="100" /></th>
        <th><img src="https://raw.githubusercontent.com/danielgatis/rembg/master/tests/results/car-1.u2net.png" width="100" /></th>
        <th><img src="https://raw.githubusercontent.com/danielgatis/rembg/master/tests/results/car-1.u2netp.png" width="100" /></th>
        <th><img src="https://raw.githubusercontent.com/danielgatis/rembg/master/tests/results/car-1.u2net_human_seg.png" width="100" /></th>
        <th><img src="https://raw.githubusercontent.com/danielgatis/rembg/master/tests/results/car-1.u2net_cloth_seg.png" width="100" /></th>
        <th><img src="https://raw.githubusercontent.com/danielgatis/rembg/master/tests/results/car-1.silueta.png" width="100" /></th>
        <th><img src="https://raw.githubusercontent.com/danielgatis/rembg/master/tests/results/car-1.isnet-general-use.png" width="100" /></th>
    </tr>
        <th><img src="https://raw.githubusercontent.com/danielgatis/rembg/master/tests/fixtures/cloth-1.jpg" width="100" /></th>
        <th><img src="https://raw.githubusercontent.com/danielgatis/rembg/master/tests/results/cloth-1.u2net.png" width="100" /></th>
        <th><img src="https://raw.githubusercontent.com/danielgatis/rembg/master/tests/results/cloth-1.u2netp.png" width="100" /></th>
        <th><img src="https://raw.githubusercontent.com/danielgatis/rembg/master/tests/results/cloth-1.u2net_human_seg.png" width="100" /></th>
        <th><img src="https://raw.githubusercontent.com/danielgatis/rembg/master/tests/results/cloth-1.u2net_cloth_seg.png" width="100" /></th>
        <th><img src="https://raw.githubusercontent.com/danielgatis/rembg/master/tests/results/cloth-1.silueta.png" width="100" /></th>
        <th><img src="https://raw.githubusercontent.com/danielgatis/rembg/master/tests/results/cloth-1.isnet-general-use.png" width="100" /></th>
    </tr>
</table>


### How to train your own model

If You need more fine tunned models try this:
https://github.com/danielgatis/rembg/issues/193#issuecomment-1055534289


## Some video tutorials

- https://www.youtube.com/watch?v=3xqwpXjxyMQ
- https://www.youtube.com/watch?v=dFKRGXdkGJU
- https://www.youtube.com/watch?v=Ai-BS_T7yjE
- https://www.youtube.com/watch?v=dFKRGXdkGJU
- https://www.youtube.com/watch?v=D7W-C0urVcQ

## References

- https://arxiv.org/pdf/2005.09007.pdf
- https://github.com/NathanUA/U-2-Net
- https://github.com/pymatting/pymatting

## Buy me a coffee

Liked some of my work? Buy me a coffee (or more likely a beer)

<a href="https://www.buymeacoffee.com/danielgatis" target="_blank"><img src="https://bmc-cdn.nyc3.digitaloceanspaces.com/BMC-button-images/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;"></a>

## License

Copyright (c) 2020-present [Daniel Gatis](https://github.com/danielgatis)

Licensed under [MIT License](./LICENSE.txt)


## starta
### mappar till port 5020
docker run -p 5020:5000 rembg s

## kör
curl -s -F file=@/mnt/c/Users/jonas/OneDrive/Bilder/ora/png/aurora-green-400.png "http://localhost:5020" -o /mnt/c/Users/jonas/OneDrive/Bilder/ora/png/ora-400-out.png

## u2netp
curl -s -F file=@/mnt/c/Users/jonas/OneDrive/Bilder/ora/png/aurora-green-400.png "http://localhost:5020?model=u2netp" -o /mnt/c/Users/jonas/OneDrive/Bilder/ora/png/ora-400-u2netp.png
curl -s -F file=@/mnt/c/Users/jonas/OneDrive/Bilder/ora/png/galaxy-beige-brown.png "http://localhost:5020?model=u2netp" -o /mnt/c/Users/jonas/OneDrive/Bilder/ora/png/galaxy-beige-brown-u2netp.png
curl -s -F file=@/mnt/c/Users/jonas/OneDrive/Bilder/ora/png/galaxy-beige-brown.png "http://localhost:5020?model=u2netp&width=400" -o /mnt/c/Users/jonas/OneDrive/Bilder/ora/png/galaxy-beige-brown-u2netp-400.png

curl -s "http://localhost:5020?model=u2netp&url=https://www.polestar.com/dato-assets/11286/1673267490-01-5-polestar-2-exterior-design-d.jpg?q=60&dpr=1&fm=pjpg&w=1440&ar=1.7777777777777777" -o /mnt/c/Users/jonas/OneDrive/Bilder/ora/png/ps2-u2netp.png

## silueta
curl -s -F file=@/mnt/c/Users/jonas/OneDrive/Bilder/ora/png/aurora-green-400.png "http://localhost:5020?model=silueta" -o /mnt/c/Users/jonas/OneDrive/Bilder/ora/png/ora-400-silueta.png
curl -s -F file=@/mnt/c/Users/jonas/OneDrive/Bilder/ora/png/galaxy-beige-brown.png "http://localhost:5020?model=silueta" -o /mnt/c/Users/jonas/OneDrive/Bilder/ora/png/galaxy-beige-brown-silueta.png
