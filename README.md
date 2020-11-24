## Requirements

* [Praat](https://www.fon.hum.uva.nl/praat/download_linux)

```sh
sudo apt-get install -y praat
```

* [HTK tools](https://github.com/open-speech/HTK)

```sh
sudo apt-get install -y gcc-multilib
git clone https://github.com/open-speech/HTK.git
cd HTK
./configure --disable-hslab
make htklib
make htktools
sudo make install-htktools
```

### For spanish

* [SAGA](https://github.com/TALP-UPC/saga)

```sh
sudo apt-get install -y meson
git clone https://github.com/TALP-UPC/saga.git
cd saga
meson builddir
cd builddir
ninja test
sudo ninja install
```

### For other supported languages

* [Wine](https://wiki.winehq.org/Download)

## Installing

```sh
sudo su -c "bash <(wget -qO- https://raw.githubusercontent.com/mlndz28/praat-easy-align-linux/master/installer.sh)" root
```

## Uninstalling

```sh
sudo su -c "bash <(wget -qO- https://raw.githubusercontent.com/mlndz28/praat-easy-align-linux/master/uninstaller.sh)" root
```


## Usage

```
easyalign [<options>] <command> [<args>]

Commands:

    macrosegmentation     Split the signal into sentences 
    phonetization         Produce a phonetic transcription
    phonesegmentation     Align the phonemes
    all                   Execute the former steps in given order

Options:
    
    -h,--help             Show usage for such command
    -o,--output <file>    Resulting TextGrid's save file 
                          Default: <audio file>.tg
    -l,--language <lan>   Change the language. Default: en

Run 'easyalign <command> --help' for more information on a command.

```