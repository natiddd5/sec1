#!/bin/bash

outdir="encryptedfiles"
plaindir="decryptedfiles"

if [ ! -d "$outdir" ]; then
    # Create the encrypted files directory if it doesn't exist
    mkdir "$outdir"
else
    # If the directory exists, check if it's empty
    if [ "$(ls -A "$outdir")" ]; then
        # If the directory is not empty, clear its contents
        rm -rf "$outdir"/*
    fi
fi

if [ ! -d "$plaindir" ]; then
    # Create the decrypted files directory if it doesn't exist
    mkdir "$plaindir"
else
    # If the directory exists, check if it's empty
    if [ "$(ls -A "$plaindir")" ]; then
        # If the directory is not empty, clear its contents
        rm -rf "$plaindir"/*
    fi
fi

echo Test1
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5000 -suite=DES/CBC/NoPadding -tempfile="encryptedfiles/Test1-TestFile2-oneblock-DES-CBC-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test1-TestFile2-oneblock-DES-CBC-NoPadding-decrypted.txt" -key=abcf77646f796f75 -iv=646f7468696e5785 > Test1-Receiver.txt &
test1_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5000 -suite=DES/CBC/NoPadding -infile="tests/TestFile2-oneblock.txt" -key=abcf77646f796f75 -iv=646f7468696e5785  > Test1-Sender.txt

sleep 10
if ps -p $test1_receiver_pid > /dev/null; then
   kill "$test1_receiver_pid"
fi

echo Test2
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5001 -suite=DES/CBC/NoPadding -tempfile="encryptedfiles/Test2-TestFile3-twoblock-DES-CBC-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test2-TestFile3-twoblock-DES-CBC-NoPadding-decrypted.txt" -key=abcf77646f796f75 -iv=646f7468696e5785  > Test2-Receiver.txt &
test2_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5001 -suite=DES/CBC/NoPadding -infile="tests/TestFile3-twoblock.txt" -key=abcf77646f796f75 -iv=646f7468696e5785   > Test2-Sender.txt

sleep 10
if ps -p $test2_receiver_pid > /dev/null; then
   kill "$test2_receiver_pid"
fi

echo Test3
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5002 -suite=DES/CBC/NoPadding -tempfile="encryptedfiles/Test3-TestFile4-twoblockisbetter-DES-CBC-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test3-TestFile4-twoblockisbetter-DES-CBC-NoPadding-decrypted.txt" -key=abcf77646f796f75 -iv=646f7469796e6773  > Test3-Receiver.txt &	
test3_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5002 -suite=DES/CBC/NoPadding -infile="tests/TestFile4-twoblockisbetter.txt" -key=abcf77646f796f75 -iv=646f7469796e6773   > Test3-Sender.txt

sleep 10
if ps -p $test3_receiver_pid > /dev/null; then
   kill "$test3_receiver_pid"
fi

echo Test4
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5003 -suite=DES/CBC/NoPadding -tempfile="encryptedfiles/Test4-TestFile6-onelongersblocks-DES-CBC-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test4-TestFile6-onelongersblocks-DES-CBC-NoPadding-decrypted.txt" -key=abcf77646f796f75 -iv=6B696C6C546F6E67 &
test4_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5003 -suite=DES/CBC/NoPadding -infile="tests/TestFile6-onelongersblocks.txt" -key=abcf77646f796f75 -iv=6B696C6C546F6E67

sleep 10
if ps -p $test4_receiver_pid > /dev/null; then
   kill "$test4_receiver_pid"
fi

echo Test5
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5004 -suite=DES/CBC/PKCS5Padding -tempfile="encryptedfiles/Test5-TestFile2-oneblock-DES-CBC-PKCS5Padding-encrypted.txt" -outfile="decryptedfiles/Test5-TestFile2-oneblock-DES-CBC-PKCS5Padding-decrypted.txt" -key=abcf77646f796f75 -iv=1AB27468696e6773	 &
test5_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5004 -suite=DES/CBC/PKCS5Padding -infile="tests/TestFile2-oneblock.txt" -key=abcf77646f796f75 -iv=1AB27468696e6773

sleep 10
if ps -p $test5_receiver_pid > /dev/null; then
   kill "$test5_receiver_pid"
fi

echo Test6
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5005 -suite=DES/CBC/PKCS5Padding -tempfile="encryptedfiles/Test6-TestFile5-one block that is not even-DES-CBC-PKCS5Padding-encrypted.txt" -outfile="decryptedfiles/Test6-TestFile5-one block that is not even-DES-CBC-PKCS5Padding-decrypted.txt" -key=abcf77646f796f75 -iv=646f7468596e6773 &	
test6_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5005 -suite=DES/CBC/PKCS5Padding -infile="tests/TestFile5-one block that is not even.txt" -key=abcf77646f796f75 -iv=646f7468596e6773

sleep 10
if ps -p $test6_receiver_pid > /dev/null; then
   kill "$test6_receiver_pid"
fi

echo Test7
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5006 -suite=DES/CBC/PKCS5Padding -tempfile="encryptedfiles/Test7-TestFile3-twoblock-DES-CBC-PKCS5Padding-encrypted.txt" -outfile="decryptedfiles/Test7-TestFile3-twoblock-DES-CBC-PKCS5Padding-decrypted.txt" -key=abcf77646f796f75 -iv=646f7468696e6773	 &
test7_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5006 -suite=DES/CBC/PKCS5Padding -infile="tests/TestFile3-twoblock.txt" -key=abcf77646f796f75 -iv=646f7468696e6773

sleep 10
if ps -p $test7_receiver_pid > /dev/null; then
   kill "$test7_receiver_pid"
fi

echo Test8
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5007 -suite=DES/CBC/PKCS5Padding -tempfile="encryptedfiles/Test8-TestFile4-twoblockisbetter-DES-CBC-PKCS5Padding-encrypted.txt" -outfile="decryptedfiles/Test8-TestFile4-twoblockisbetter-DES-CBC-PKCS5Padding-decrypted.txt" -key=abcf77646f796f75 -iv=646f7468696e6773 &	
test8_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5007 -suite=DES/CBC/PKCS5Padding -infile="tests/TestFile4-twoblockisbetter.txt" -key=abcf77646f796f75 -iv=646f7468696e6773

sleep 10
if ps -p $test8_receiver_pid > /dev/null; then
   kill "$test8_receiver_pid"
fi

echo Test9
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5008 -suite=DES/CBC/PKCS5Padding -tempfile="encryptedfiles/Test9-TestFile1-Gutenberg-DES-CBC-PKCS5Padding-encrypted.txt" -outfile="decryptedfiles/Test9-TestFile1-Gutenberg-DES-CBC-PKCS5Padding-decrypted.txt" -key=686F77646F798294 -iv=6B696D6C6D6F6E67 &	
test9_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5008 -suite=DES/CBC/PKCS5Padding -infile="tests/TestFile1-Gutenberg.txt" -key=686F77646F798294 -iv=6B696D6C6D6F6E67

sleep 10
if ps -p $test9_receiver_pid > /dev/null; then
   kill "$test9_receiver_pid"
fi

echo Test10
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5009 -suite=DES/CBC/PKCS5Padding -tempfile="encryptedfiles/Test10-Alabama-DES-CBC-PKCS5Padding-encrypted.pdf" -outfile="decryptedfiles/Test10-Alabama-DES-CBC-PKCS5Padding-decrypted.pdf" -key=686F77646F798294 -iv=6B696C6C6D6F6E65	 &
test10_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5009 -suite=DES/CBC/PKCS5Padding -infile="tests/Alabama.pdf" -key=686F77646F798294 -iv=6B696C6C6D6F6E65

sleep 10
if ps -p $test10_receiver_pid > /dev/null; then
   kill "$test10_receiver_pid"
fi

echo Test11
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5010 -suite=DES/CTR/NoPadding -tempfile="encryptedfiles/Test11-TestFile2-oneblock-DES-CTR-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test11-TestFile2-oneblock-DES-CTR-NoPadding-decrypted.txt" -key=686F77646F798294 -iv=646f7668696e6773 &	
test11_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5010 -suite=DES/CTR/NoPadding -infile="tests/TestFile2-oneblock.txt" -key=686F77646F798294 -iv=646f7668696e6773

sleep 10
if ps -p $test11_receiver_pid > /dev/null; then
   kill "$test11_receiver_pid"
fi

echo Test12
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5011 -suite=DES/CTR/NoPadding -tempfile="encryptedfiles/Test12-TestFile3-twoblock-DES-CTR-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test12-TestFile3-twoblock-DES-CTR-NoPadding-decrypted.txt" -key=686F77646F798294 -iv=645f7468696e6773	 &
test12_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5011 -suite=DES/CTR/NoPadding -infile="tests/TestFile3-twoblock.txt" -key=686F77646F798294 -iv=645f7468696e6773

sleep 10
if ps -p $test12_receiver_pid > /dev/null; then
   kill "$test12_receiver_pid"
fi

echo Test13
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5012 -suite=DES/CTR/NoPadding -tempfile="encryptedfiles/Test13-TestFile4-twoblockisbetter-DES-CTR-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test13-TestFile4-twoblockisbetter-DES-CTR-NoPadding-decrypted.txt" -key=686F77646F798294 -iv=246f7468696e6773	 &
test13_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5012 -suite=DES/CTR/NoPadding -infile="tests/TestFile4-twoblockisbetter.txt" -key=686F77646F798294 -iv=246f7468696e6773

sleep 10
if ps -p $test13_receiver_pid > /dev/null; then
   kill "$test13_receiver_pid"
fi

echo Test14
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5013 -suite=DES/CTR/NoPadding -tempfile="encryptedfiles/Test14-TestFile1-Gutenberg-DES-CTR-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test14-TestFile1-Gutenberg-DES-CTR-NoPadding-decrypted.txt" -key=686F77646F798294 -iv=4B696C6C6D6F6E67	 &
test14_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5013 -suite=DES/CTR/NoPadding -infile="tests/TestFile1-Gutenberg.txt" -key=686F77646F798294 -iv=4B696C6C6D6F6E67

sleep 10
if ps -p $test14_receiver_pid > /dev/null; then
   kill "$test14_receiver_pid"
fi

echo Test15
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5014 -suite=DES/CTR/NoPadding -tempfile="encryptedfiles/Test15-Alabama-DES-CTR-NoPadding-encrypted.pdf" -outfile="decryptedfiles/Test15-Alabama-DES-CTR-NoPadding-decrypted.pdf" -key=686F78192F796F75 -iv=8B696C6C6D6F6E67	 &
test15_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5014 -suite=DES/CTR/NoPadding -infile="tests/Alabama.pdf" -key=686F78192F796F75 -iv=8B696C6C6D6F6E67

sleep 10
if ps -p $test15_receiver_pid > /dev/null; then
   kill "$test15_receiver_pid"
fi

echo Test16
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5015 -suite=AES/CBC/NoPadding -tempfile="encryptedfiles/Test16-TestFile6-onelongersblocks-AES-CBC-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test16-TestFile6-onelongersblocks-AES-CBC-NoPadding-decrypted.txt" -key=6B696C6C696E67796F755575796A6F6E -iv=7374726F6E676261646D616473616473	 &
test16_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5015 -suite=AES/CBC/NoPadding -infile="tests/TestFile6-onelongersblocks.txt" -key=6B696C6C696E67796F755575796A6F6E -iv=7374726F6E676261646D616473616473

sleep 10
if ps -p $test16_receiver_pid > /dev/null; then
   kill "$test16_receiver_pid"
fi

echo Test17
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5016 -suite=AES/CBC/NoPadding -tempfile="encryptedfiles/Test17-TestFile7-twobetterthanone-AES-CBC-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test17-TestFile7-twobetterthanone-AES-CBC-NoPadding-decrypted.txt" -key=7A696C6C6F77777342696E7377617273 -iv=7374726F6E676261646D616473616473	 &
test17_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5016 -suite=AES/CBC/NoPadding -infile="tests/TestFile7-twobetterthanone.txt" -key=7A696C6C6F77777342696E7377617273 -iv=7374726F6E676261646D616473616473

sleep 10
if ps -p $test17_receiver_pid > /dev/null; then
   kill "$test17_receiver_pid"
fi

echo Test18
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5017 -suite=AES/CBC/NoPadding -tempfile="encryptedfiles/Test18-TestFile8-onelongerblocktwoisbetterthanone-AES-CBC-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test18-TestFile8-onelongerblocktwoisbetterthanone-AES-CBC-NoPadding-decrypted.txt" -key=6B696C65196E67796F756775796A6F6E -iv=7374726F6E676261646D616473616473 &	
test18_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5017 -suite=AES/CBC/NoPadding -infile="tests/TestFile8-onelongerblocktwoisbetterthanone.txt" -key=6B696C65196E67796F756775796A6F6E -iv=7374726F6E676261646D616473616473

sleep 10
if ps -p $test18_receiver_pid > /dev/null; then
   kill "$test18_receiver_pid"
fi

echo Test19
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5018 -suite=AES/CBC/NoPadding -tempfile="encryptedfiles/Test19-TestFile10-twobetterthanonequietonthewesternfrontuntiitsoverandtingsbreakup-AES-CBC-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test19-TestFile10-twobetterthanonequietonthewesternfrontuntiitsoverandtingsbreakup-AES-CBC-NoPadding-decrypted.txt" -key=7A696C6C6F77777377696E7379817273 -iv=736576656E6A756E696F726D696E7473	 &
test19_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5018 -suite=AES/CBC/NoPadding -infile="tests/TestFile10-twobetterthanonequietonthewesternfrontuntiitsoverandtingsbreakup.txt" -key=7A696C6C6F77777377696E7379817273 -iv=736576656E6A756E696F726D696E7473

sleep 10
if ps -p $test19_receiver_pid > /dev/null; then
   kill "$test19_receiver_pid"
fi

echo Test20
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5019 -suite=AES/CBC/PKCS5Padding -tempfile="encryptedfiles/Test20-TestFile9-twobetterthanonequietonthewesternfront-AES-CBC-PKCS5Padding-encrypted.txt" -outfile="decryptedfiles/Test20-TestFile9-twobetterthanonequietonthewesternfront-AES-CBC-PKCS5Padding-decrypted.txt" -key=7A696C6C6F77777377696E7377617273696E746F68656174 -iv=736576656E6A756E696F726D696E7473	 &
test20_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5019 -suite=AES/CBC/PKCS5Padding -infile="tests/TestFile9-twobetterthanonequietonthewesternfront.txt" -key=7A696C6C6F77777377696E7377617273696E746F68656174 -iv=736576656E6A756E696F726D696E7473

sleep 10
if ps -p $test20_receiver_pid > /dev/null; then
   kill "$test20_receiver_pid"
fi

echo Test21
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5020 -suite=AES/CBC/PKCS5Padding -tempfile="encryptedfiles/Test21-TestFile10-twobetterthanonequietonthewesternfrontuntiitsoverandtingsbreakup-AES-CBC-PKCS5Padding-encrypted.txt" -outfile="decryptedfiles/Test21-TestFile10-twobetterthanonequietonthewesternfrontuntiitsoverandtingsbreakup-AES-CBC-PKCS5Padding-decrypted.txt" -key=7A696C6C6F77777377696E7377617273696E748868656172 -iv=736576656E6A756E696F726D696E7473	 &
test21_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5020 -suite=AES/CBC/PKCS5Padding -infile="tests/TestFile10-twobetterthanonequietonthewesternfrontuntiitsoverandtingsbreakup.txt" -key=7A696C6C6F77777377696E7377617273696E748868656172 -iv=736576656E6A756E696F726D696E7473

sleep 10
if ps -p $test21_receiver_pid > /dev/null; then
   kill "$test21_receiver_pid"
fi

echo Test22
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5021 -suite=AES/CBC/PKCS5Padding -tempfile="encryptedfiles/Test22-TestFile10-twobetterthanonequietonthewesternfrontuntiitsoverandtingsbreakup-AES-CBC-PKCS5Padding-encrypted.txt" -outfile="decryptedfiles/Test22-TestFile10-twobetterthanonequietonthewesternfrontuntiitsoverandtingsbreakup-AES-CBC-PKCS5Padding-decrypted.txt" -key=7A696C6C6567777377696E7377617273696E746F6865617271756F746171696B -iv=736576656E6A756E696F726D696E7473	 &
test22_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5021 -suite=AES/CBC/PKCS5Padding -infile="tests/TestFile10-twobetterthanonequietonthewesternfrontuntiitsoverandtingsbreakup.txt" -key=7A696C6C6567777377696E7377617273696E746F6865617271756F746171696B -iv=736576656E6A756E696F726D696E7473

sleep 10
if ps -p $test22_receiver_pid > /dev/null; then
   kill "$test22_receiver_pid"
fi

echo Test23
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5022 -suite=AES/CBC/PKCS5Padding -tempfile="encryptedfiles/Test23-TestFile1-Gutenberg-AES-CBC-PKCS5Padding-encrypted.txt" -outfile="decryptedfiles/Test23-TestFile1-Gutenberg-AES-CBC-PKCS5Padding-decrypted.txt" -key=7A696C6C6F77777377696E7375217273696E746F6865617271756F746171696B -iv=736576656E6A756E696F726D696E7473	 &
test23_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5022 -suite=AES/CBC/PKCS5Padding -infile="tests/TestFile1-Gutenberg.txt" -key=7A696C6C6F77777377696E7375217273696E746F6865617271756F746171696B -iv=736576656E6A756E696F726D696E7473

sleep 10
if ps -p $test23_receiver_pid > /dev/null; then
   kill "$test23_receiver_pid"
fi

echo Test24
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5023 -suite=AES/CBC/PKCS5Padding -tempfile="encryptedfiles/Test24-Alabama-AES-CBC-PKCS5Padding-encrypted.pdf" -outfile="decryptedfiles/Test24-Alabama-AES-CBC-PKCS5Padding-decrypted.pdf" -key=7A696C6C6F77777377696E7377617273696E746F7165617271756F746171696B -iv=736576656E6A756E696F726D696E7473	 &
test24_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5023 -suite=AES/CBC/PKCS5Padding -infile="tests/Alabama.pdf" -key=7A696C6C6F77777377696E7377617273696E746F7165617271756F746171696B -iv=736576656E6A756E696F726D696E7473

sleep 10
if ps -p $test24_receiver_pid > /dev/null; then
   kill "$test24_receiver_pid"
fi

echo Test25
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5024 -suite=AES/CTR/NoPadding -tempfile="encryptedfiles/Test25-TestFile6-onelongersblocks-AES-CTR-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test25-TestFile6-onelongersblocks-AES-CTR-NoPadding-decrypted.txt" -key=6B696C6C696E67796F756775796A6F65 -iv=7374726F6E676261646D616473616473	 &
test25_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5024 -suite=AES/CTR/NoPadding -infile="tests/TestFile6-onelongersblocks.txt" -key=6B696C6C696E67796F756775796A6F65 -iv=7374726F6E676261646D616473616473

sleep 10
if ps -p $test25_receiver_pid > /dev/null; then
   kill "$test25_receiver_pid"
fi

echo Test26
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5025 -suite=AES/CTR/NoPadding -tempfile="encryptedfiles/Test26-TestFile7-twobetterthanone-AES-CTR-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test26-TestFile7-twobetterthanone-AES-CTR-NoPadding-decrypted.txt" -key=7A696C6C6F77787377696E7377617273 -iv=7374726F6E676261646D616473616473 &
test26_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5025 -suite=AES/CTR/NoPadding -infile="tests/TestFile7-twobetterthanone.txt" -key=7A696C6C6F77787377696E7377617273 -iv=7374726F6E676261646D616473616473

sleep 10
if ps -p $test26_receiver_pid > /dev/null; then
   kill "$test26_receiver_pid"
fi

echo Test27
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5026 -suite=AES/CTR/NoPadding -tempfile="encryptedfiles/Test27-TestFile8-onelongerblocktwoisbetterthanone-AES-CTR-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test27-TestFile8-onelongerblocktwoisbetterthanone-AES-CTR-NoPadding-decrypted.txt" -key=CB696C6C696E67796F756775796A6F6E -iv=7374726F6E676261646D616473616473 &
test27_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5026 -suite=AES/CTR/NoPadding -infile="tests/TestFile8-onelongerblocktwoisbetterthanone.txt" -key=CB696C6C696E67796F756775796A6F6E -iv=7374726F6E676261646D616473616473

sleep 10
if ps -p $test27_receiver_pid > /dev/null; then
   kill "$test27_receiver_pid"
fi

echo Test28
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5027 -suite=AES/CTR/NoPadding -tempfile="encryptedfiles/Test28-TestFile1-Gutenberg-AES-CTR-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test28-TestFile1-Gutenberg-AES-CTR-NoPadding-decrypted.txt" -key=9B696C6C6F77777377696E7377617273696E746F68656172 -iv=736576656E6A756E696F726D696E7473 &
test28_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5027 -suite=AES/CTR/NoPadding -infile="tests/TestFile1-Gutenberg.txt" -key=9B696C6C6F77777377696E7377617273696E746F68656172 -iv=736576656E6A756E696F726D696E7473

sleep 10
if ps -p $test28_receiver_pid > /dev/null; then
   kill "$test28_receiver_pid"
fi

echo Test29
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5028 -suite=AES/CTR/NoPadding -tempfile="encryptedfiles/Test29-Alabama-AES-CTR-NoPadding-encrypted.pdf" -outfile="decryptedfiles/Test29-Alabama-AES-CTR-NoPadding-decrypted.pdf" -key=7A696C6C6F77779577696E7377617273696E746F68656172 -iv=736576656E6A756E696F726D696E7473 &
test29_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5028 -suite=AES/CTR/NoPadding -infile="tests/Alabama.pdf" -key=7A696C6C6F77779577696E7377617273696E746F68656172 -iv=736576656E6A756E696F726D696E7473

sleep 10
if ps -p $test29_receiver_pid > /dev/null; then
   kill "$test29_receiver_pid"
fi

echo Test30
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5029 -suite=AES/CTR/NoPadding -tempfile="encryptedfiles/Test30-Alaska-AES-CTR-NoPadding-encrypted.pdf" -outfile="decryptedfiles/Test30-Alaska-AES-CTR-NoPadding-decrypted.pdf" -key=68756E647265647965617273776172697774726F64756374696F6E696E746865 -iv=6974776173746865626573746F666D65 &
test30_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5029 -suite=AES/CTR/NoPadding -infile="tests/Alaska.pdf" -key=68756E647265647965617273776172697774726F64756374696F6E696E746865 -iv=6974776173746865626573746F666D65

sleep 10
if ps -p $test30_receiver_pid > /dev/null; then
   kill "$test30_receiver_pid"
fi

echo Test31
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5030 -suite=AES/GCM/NoPadding -tempfile="encryptedfiles/Test31-TestFile6-onelongersblocks-AES-GCM-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test31-TestFile6-onelongersblocks-AES-GCM-NoPadding-decrypted.txt" -key=6B696C6C696E67796F756775796A6F62 -iv=7374726F6E676261646D616473616473 -taglength=128 &
test31_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5030 -suite=AES/GCM/NoPadding -infile="tests/TestFile6-onelongersblocks.txt" -key=6B696C6C696E67796F756775796A6F62 -iv=7374726F6E676261646D616473616473 -taglength=128

sleep 10
if ps -p $test31_receiver_pid > /dev/null; then
   kill "$test31_receiver_pid"
fi

echo Test32
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5031 -suite=AES/GCM/NoPadding -tempfile="encryptedfiles/Test32-TestFile7-twobetterthanone-AES-GCM-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test32-TestFile7-twobetterthanone-AES-GCM-NoPadding-decrypted.txt" -key=7A696C6C6F77127377696E7377617273 -iv=7374726F6E676261646D616473616473 -taglength=128 &
test32_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5031 -suite=AES/GCM/NoPadding -infile="tests/TestFile7-twobetterthanone.txt" -key=7A696C6C6F77127377696E7377617273 -iv=7374726F6E676261646D616473616473 -taglength=128

sleep 10
if ps -p $test32_receiver_pid > /dev/null; then
   kill "$test32_receiver_pid"
fi

echo Test33
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5032 -suite=AES/GCM/NoPadding -tempfile="encryptedfiles/Test33-TestFile8-onelongerblocktwoisbetterthanone-AES-GCM-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test33-TestFile8-onelongerblocktwoisbetterthanone-AES-GCM-NoPadding-decrypted.txt" -key=6B696C33696E67796F756775796A6F6E -iv=7374726F6E676261646D616473616473 -taglength=128 &
test33_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5032 -suite=AES/GCM/NoPadding -infile="tests/TestFile8-onelongerblocktwoisbetterthanone.txt" -key=6B696C33696E67796F756775796A6F6E -iv=7374726F6E676261646D616473616473 -taglength=128

sleep 10
if ps -p $test33_receiver_pid > /dev/null; then
   kill "$test33_receiver_pid"
fi

echo Test34
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5033 -suite=AES/GCM/NoPadding -tempfile="encryptedfiles/Test34-TestFile1-Gutenberg-AES-GCM-NoPadding-encrypted.txt" -outfile="decryptedfiles/Test34-TestFile1-Gutenberg-AES-GCM-NoPadding-decrypted.txt" -key=7A696C6C6F77777377696E7377617453696E746F68656172 -iv=736576656E6A756E696F726D696E7473 -taglength=128 &
test34_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5033 -suite=AES/GCM/NoPadding -infile="tests/TestFile1-Gutenberg.txt" -key=7A696C6C6F77777377696E7377617453696E746F68656172 -iv=736576656E6A756E696F726D696E7473 -taglength=128

sleep 10
if ps -p $test34_receiver_pid > /dev/null; then
   kill "$test34_receiver_pid"
fi

echo Test35
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5034 -suite=AES/GCM/NoPadding -tempfile="encryptedfiles/Test35-Alabama-AES-GCM-NoPadding-encrypted.pdf" -outfile="decryptedfiles/Test35-Alabama-AES-GCM-NoPadding-decrypted.pdf" -key=7A696C6C6F77777377696E7377617273696E746F68656286 -iv=736576656E6A756E696F726D696E7473 -taglength=128 &
test35_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5034 -suite=AES/GCM/NoPadding -infile="tests/Alabama.pdf" -key=7A696C6C6F77777377696E7377617273696E746F68656286 -iv=736576656E6A756E696F726D696E7473 -taglength=128

sleep 10
if ps -p $test35_receiver_pid > /dev/null; then
   kill "$test35_receiver_pid"
fi

echo Test36
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5035 -suite=AES/GCM/NoPadding -tempfile="encryptedfiles/Test36-Alaska-AES-GCM-NoPadding-encrypted.pdf" -outfile="decryptedfiles/Test36-Alaska-AES-GCM-NoPadding-decrypted.pdf" -key=68756E647265647965617412776172696E74726F64756374696F6E696E746865 -iv=6974776173746865626573746F666D65 -taglength=128 &
test36_receiver_pid=$!
sleep 3
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5035 -suite=AES/GCM/NoPadding -infile="tests/Alaska.pdf" -key=68756E647265647965617412776172696E74726F64756374696F6E696E746865 -iv=6974776173746865626573746F666D65 -taglength=128

sleep 10
if ps -p $test36_receiver_pid > /dev/null; then
   kill "$test36_receiver_pid"
fi

echo Test 37 Sender Usage
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5037 -infile="tests/Alaska.pdf" -key=68756E647265647965617412776172696E74726F64756374696F6E696E746865 -iv=6974776173746865626573746F666D65 -taglength=128 > Test37-sender-usage.txt

echo Test 38 Sender Usage
java -jar Sender-5785.jar -dest=abcd.0.0.1 -port=5038 -suite=AES/GCM/NoPadding -infile="tests/Alaska.pdf" -key=68756E647265647965617412776172696E74726F64756374696F6E696E746865 -iv=6974776173746865626573746F666D65 -taglength=128  > Test38-sender-usage.txt

echo Test 39 Sender Usage
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5039 -suite=ACM/GCM/NoPadding -infile="tests/Alaska.pdf" -key=68756E647265647965617412776172696E74726F64756374696F6E696E746865 -iv=6974776173746865626573746F666D65 -taglength=128  > Test39-sender-usage.txt

echo Test 40 Sender Usage
java -jar Sender-5785.jar -dest=127.0.0.1 -port=5040 -suite=AES/GCM/NoPadding -infile="tests/Alaska.pdf" -key=68756E64726564796561741276 -iv=6974776173746865626573746F666D65 -taglength=128  > Test40-sender-usage.txt

echo Test 41 Receiver Usage
java -jar Receiver-5785.jar -ip=127.0.0.1 -suite=AES/GCM/NoPadding -tempfile="encryptedfiles/Test36-Alaska-AES-GCM-NoPadding-encrypted.pdf" -outfile="decryptedfiles/Test36-Alaska-AES-GCM-NoPadding-decrypted.pdf" -key=68756E647265647965617412776172696E74726F64756374696F6E696E746865 -iv=6974776173746865626573746F666D65 -taglength=128 > Test41-receiver-usage.txt &
test41_receiver_pid=$!
sleep 5
if ps -p $test41_receiver_pid > /dev/null; then
   kill "$test41_receiver_pid"
fi

echo Test 42 Receiver Usage
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5042 -suite=ACM/GCM/NoPadding -tempfile="encryptedfiles/Test36-Alaska-AES-GCM-NoPadding-encrypted.pdf" -outfile="decryptedfiles/Test36-Alaska-AES-GCM-NoPadding-decrypted.pdf" -key=68756E647265647965617412776172696E74726F64756374696F6E696E746865 -iv=6974776173746865626573746F666D65 -taglength=128 > Test42-receiver-usage.txt & 
test42_receiver_pid=$!
sleep 10
if ps -p $test42_receiver_pid > /dev/null; then
   kill "$test42_receiver_pid"
fi

echo Test 43 Receiver Usage
java -jar Receiver-5785.jar -ip=127.0.0.1 -port=5044 -suite=AES/GCM/NoPadding -tempfile="encryptedfiles/Test36-Alaska-AES-GCM-NoPadding-encrypted.pdf" -outfile="decryptedfiles/Test36-Alaska-AES-GCM-NoPadding-decrypted.pdf" -key=68756E647265647965617412776172696E74726F64756374696F6E696E746865 -iv=69747876 -taglength=128 > Test43-receiver-usage.txt &
test43_receiver_pid=$!
sleep 10
if ps -p $test43_receiver_pid > /dev/null; then
   kill "$test43_receiver_pid"
fi

sha256sum "$outdir"/* > "$outdir"/encrypted-files.sha256
sha256sum "$plaindir"/* > "$plaindir"/decryptedfiles.sha256

sha256sum -c ./encrypted-files.sha256
sha256sum -c ./decryptedfiles.sha256
