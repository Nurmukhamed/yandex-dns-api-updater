#!/bin/bash

# Encrypt archive and extract archive
openssl aes-256-cbc -K $encrypted_a89191c56639_key -iv $encrypted_a89191c56639_iv -in encryptedfiles.tar.enc -out encryptedfiles.tar -d
tar xvf encryptedfiles.tar
rm encryptedfiles.tar

