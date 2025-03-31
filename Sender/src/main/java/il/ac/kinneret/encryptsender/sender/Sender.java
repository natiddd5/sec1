package il.ac.kinneret.encryptsender.sender;

import il.ac.kinneret.encryptsender.sender.util.Constants;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.GCMParameterSpec;
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
    private boolean isGCM;
    private String dest;
    private int port;
    private String suite;
    private String infile;
    private byte[] key;
    private byte[] iv;
    private int tagLength; // used for GCM mode only

    public Sender(String dest, int port, String suite,
                  String infile, byte[] key, byte[] iv,
                  int tagLength) {
        this.dest = dest;
        this.port = port;
        this.suite = suite;
        this.infile = infile;
        this.key = key;
        this.iv = iv;
        this.tagLength = tagLength;
        extractCipherMetadataFromSuite(suite);
    }

    private void extractCipherMetadataFromSuite(String suite) {
        // For example, "AES/CBC/NoPadding" or "DES/CTR/NoPadding"
        String[] parts = suite.split("/");
        algorithm = parts[0]; // e.g. "AES" or "DES"

        // Check for GCM
        isGCM = suite.toUpperCase().contains("GCM");

        // For AES, blockSize = 16; for DES, blockSize = 8
        if (algorithm.equalsIgnoreCase("AES")) {
            blockSize = 16;
        } else if (algorithm.equalsIgnoreCase("DES")) {
            blockSize = 8;
        } else {
            // handle other ciphers as needed
            blockSize = 16;
        }

        // If the suite string has "NoPadding", isPadding = false, else true
        // (Except we treat GCM differently, so isPadding is irrelevant in that branch.)
        isPadding = !suite.toUpperCase().contains("NOPADDING") || isGCM;
    }

    private void validateKey() {
        // Example key-length checks for AES or DES
        if (algorithm.equalsIgnoreCase("AES")) {
            if (key.length != 16 && key.length != 24 && key.length != 32) {
                System.out.printf("Error: Invalid key length for AES: %d bytes\n", key.length);
                System.out.printf("Error sending file: Connection refused\n");
                System.exit(0);
            }
        } else if (algorithm.equalsIgnoreCase("DES")) {
            // DES requires exactly 8 bytes
            if (key.length != 8) {
                System.out.printf("Error: Invalid key length for DES: %d bytes\n", key.length);
                System.out.printf("Error sending file: Connection refused\n");
                System.exit(0);
            }
        }
        // else handle other ciphers, if needed
    }

    public void sendMessage() {
        validateKey();

        try (Socket socket = new Socket(dest, port);
             FileInputStream fileIn = new FileInputStream(infile)) {

            Cipher cipher = Cipher.getInstance(suite);
            SecretKeySpec secretKeySpec = new SecretKeySpec(key, algorithm);

            // Decide which block of logic to use based on GCM/padding/CTR
            if (isGCM) {
                // GCM branch
                GCMParameterSpec gcmSpec = new GCMParameterSpec(tagLength, iv);
                cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, gcmSpec);

                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fileIn.read(buffer)) != -1) {
                    byte[] encrypted = cipher.update(buffer, 0, bytesRead);
                    if (encrypted != null && encrypted.length > 0) {
                        socket.getOutputStream().write(encrypted);
                    }
                }
                byte[] finalBytes = cipher.doFinal();
                if (finalBytes != null && finalBytes.length > 0) {
                    socket.getOutputStream().write(finalBytes);
                }
                socket.getOutputStream().flush();
                System.out.printf(Constants.SENT_FILE, infile);

            } else if (suite.toUpperCase().contains("CTR")) {
                // CTR mode is inherently streaming, so no leftover/padding needed
                IvParameterSpec ivSpec = new IvParameterSpec(iv);
                cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivSpec);

                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fileIn.read(buffer)) != -1) {
                    byte[] encrypted = cipher.update(buffer, 0, bytesRead);
                    if (encrypted != null && encrypted.length > 0) {
                        socket.getOutputStream().write(encrypted);
                    }
                }
                byte[] finalBytes = cipher.doFinal();
                if (finalBytes != null && finalBytes.length > 0) {
                    socket.getOutputStream().write(finalBytes);
                }
                socket.getOutputStream().flush();
                System.out.printf(Constants.SENT_FILE, infile);

            } else if (isPadding) {
                // e.g. AES/CBC/PKCS5Padding or DES/CBC/PKCS5Padding
                IvParameterSpec ivSpec = new IvParameterSpec(iv);
                cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivSpec);

                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fileIn.read(buffer)) != -1) {
                    byte[] encrypted = cipher.update(buffer, 0, bytesRead);
                    if (encrypted != null && encrypted.length > 0) {
                        socket.getOutputStream().write(encrypted);
                    }
                }
                byte[] finalBytes = cipher.doFinal();
                if (finalBytes != null && finalBytes.length > 0) {
                    socket.getOutputStream().write(finalBytes);
                }
                socket.getOutputStream().flush();
                System.out.printf(Constants.SENT_FILE, infile);

            } else {
                // e.g. CBC/NoPadding scenario – the leftover logic remains
                IvParameterSpec ivSpec = new IvParameterSpec(iv);
                cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivSpec);

                byte[] buffer = new byte[4096];
                byte[] leftover = new byte[0];
                int bytesRead;

                while ((bytesRead = fileIn.read(buffer)) != -1) {
                    // Combine leftover + newly read
                    byte[] combined = new byte[leftover.length + bytesRead];
                    System.arraycopy(leftover, 0, combined, 0, leftover.length);
                    System.arraycopy(buffer, 0, combined, leftover.length, bytesRead);

                    // Encrypt all full blocks
                    int fullLen = (combined.length / blockSize) * blockSize;
                    int remainder = combined.length - fullLen;

                    if (fullLen > 0) {
                        byte[] toEncrypt = Arrays.copyOfRange(combined, 0, fullLen);
                        byte[] encrypted = cipher.update(toEncrypt);
                        if (encrypted != null && encrypted.length > 0) {
                            socket.getOutputStream().write(encrypted);
                        }
                    }

                    // leftover partial block
                    leftover = (remainder > 0)
                            ? Arrays.copyOfRange(combined, fullLen, combined.length)
                            : new byte[0];
                }
                // If leftover remains, zero-pad it to full block
                if (leftover.length > 0) {
                    byte[] padded = new byte[blockSize];
                    System.arraycopy(leftover, 0, padded, 0, leftover.length);
                    byte[] encrypted = cipher.update(padded);
                    if (encrypted != null && encrypted.length > 0) {
                        socket.getOutputStream().write(encrypted);
                    }
                }
                byte[] finalBytes = cipher.doFinal();
                if (finalBytes != null && finalBytes.length > 0) {
                    socket.getOutputStream().write(finalBytes);
                }
                socket.getOutputStream().flush();
                System.out.printf(Constants.SENT_FILE, infile);
            }

        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (InvalidKeyException e) {
            String algorithmUpper = suite.split("/")[0].toUpperCase();
            String message = String.format(
                    "Error: Invalid key when encrypting: Invalid %s key length: %d bytes\n",
                    algorithmUpper, key.length
            );
            System.out.printf(message + "Error sending file: Connection refused\n");
            System.exit(0);
        } catch (NoSuchPaddingException e) {
            Main.showUsage(Constants.INVALID_PADDING_ALGORITHM);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        } catch (InvalidAlgorithmParameterException e) {
            throw new RuntimeException(e);
        } catch (BadPaddingException e) {
            throw new RuntimeException(e);
        } catch (IllegalBlockSizeException e) {
            throw new RuntimeException(e);
        }
    }
}
