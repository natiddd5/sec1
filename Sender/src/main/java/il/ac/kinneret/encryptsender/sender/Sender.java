package il.ac.kinneret.encryptsender.sender;

import il.ac.kinneret.encryptsender.sender.util.Constants;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.Socket;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

public class Sender {

    private String algorithm;
    private int blockSize;
    private boolean isPadding;

    private String dest;
    private int port;
    private String suite;
    private String infile;
    private byte[] key;
    private byte[] iv;




    public Sender(String dest, int port, String suite, String infile, byte[] key, byte[] iv) {
        this.dest = dest;
        this.port = port;
        this.suite = suite;
        this.infile = infile;
        this.key = key;
        this.iv = iv;
        extractCipherMetadataFromSuite(suite);
    }

    private void extractCipherMetadataFromSuite(String suite){
        algorithm = suite.split("/")[0]; // ASSUME CORRECT INPUT IN THE FORM "AES/CBC/NoPadding"
        blockSize = algorithm.equals("AES") ? 16 : 8; // AES has a block size of 16 bytes, DES has a block size of 8 bytes4            boolean noPadding = suite.toUpperCase().contains("NOPADDING");
         this.isPadding = suite.toUpperCase().contains("NOPADDING") ? false : true;

    }

    public void sendMessage() {
        try(Socket socket = new Socket(dest, port); FileInputStream fileInputStream = new FileInputStream(infile);) {

            Cipher cipher = Cipher.getInstance(suite);
            SecretKeySpec secretKeySpec = new SecretKeySpec(key, algorithm);
            IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);

            cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec);
            if(isPadding){
                byte[] buffer = new byte[4096];
                int bytesRead;

                while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                    byte[] encrypted = cipher.update(buffer,0,bytesRead);
                    if (encrypted != null && encrypted.length > 0) {
                        socket.getOutputStream().write(encrypted);
                    }
                }

                // Finish encryption (final block + padding)
                byte[] finalBytes = cipher.doFinal();
                if (finalBytes != null && finalBytes.length > 0) {
                    socket.getOutputStream().write(finalBytes);
                }

                socket.getOutputStream().flush();
            } else {
                // === NoPadding scenario ===
                byte[] buffer = new byte[4096];
                byte[] leftover = new byte[0];
                int bytesRead;

                while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                    // Combine leftover + newly read bytes
                    byte[] combined = new byte[leftover.length + bytesRead];
                    System.arraycopy(leftover, 0, combined, 0, leftover.length);
                    System.arraycopy(buffer, 0, combined, leftover.length, bytesRead);

                    // Determine how many full blocks we have
                    int fullLen = (combined.length / blockSize) * blockSize;
                    int remainder = combined.length - fullLen;

                    // Encrypt all full blocks
                    if (fullLen > 0) {
                        byte[] toEncrypt = Arrays.copyOfRange(combined, 0, fullLen);
                        byte[] encrypted = cipher.update(toEncrypt);
                        if (encrypted != null && encrypted.length > 0) {
                            socket.getOutputStream().write(encrypted);
                        }
                    }

                    // Save leftover partial block
                    if (remainder > 0) {
                        leftover = Arrays.copyOfRange(combined, fullLen, combined.length);
                    } else {
                        leftover = new byte[0];
                    }
                }

                // After reading the entire file, if leftover is not empty, we must pad it ourselves.
                if (leftover.length > 0) {
                    // Zero-pad the leftover to a full block
                    byte[] padded = new byte[blockSize];
                    System.arraycopy(leftover, 0, padded, 0, leftover.length);

                    // Encrypt the padded block
                    byte[] encrypted = cipher.update(padded);
                    if (encrypted != null && encrypted.length > 0) {
                        socket.getOutputStream().write(encrypted);
                    }
                }

                // Finally, call doFinal() exactly once to flush any internal buffers
                byte[] finalBytes = cipher.doFinal();
                if (finalBytes != null && finalBytes.length > 0) {
                    socket.getOutputStream().write(finalBytes);
                }

                socket.getOutputStream().flush();
                System.out.printf(Constants.SENT_FILE, infile);
        }

        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (NoSuchPaddingException e) {
            throw new RuntimeException(e);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        } catch (InvalidAlgorithmParameterException e) {
            throw new RuntimeException(e);
        } catch (InvalidKeyException e) {
            throw new RuntimeException(e);
        } catch (IllegalBlockSizeException e) {
            throw new RuntimeException(e);
        } catch (BadPaddingException e) {
            throw new RuntimeException(e);
        }


    }
}
