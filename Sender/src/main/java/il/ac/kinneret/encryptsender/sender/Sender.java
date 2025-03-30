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
    private int tagLength; // used only in GCM mode

    public Sender(String dest, int port, String suite, String infile, byte[] key, byte[] iv, int tagLength) {
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
        // Expecting a suite in the form "AES/CBC/NoPadding" or "AES/GCM/NoPadding"
        algorithm = suite.split("/")[0];
        if (suite.toUpperCase().contains("GCM")) {
            isGCM = true;
            // Block size is less important in GCM mode, but we set it for consistency.
            blockSize = algorithm.equals("AES") ? 16 : 8;
        } else {
            isGCM = false;
            blockSize = algorithm.equals("AES") ? 16 : 8;
            isPadding = suite.toUpperCase().contains("NOPADDING") ? false : true;
        }
    }

    public void sendMessage() {
        try (Socket socket = new Socket(dest, port);
             FileInputStream fileInputStream = new FileInputStream(infile)) {

            Cipher cipher = Cipher.getInstance(suite);
            SecretKeySpec secretKeySpec = new SecretKeySpec(key, algorithm);

            if (isGCM) {
                // For GCM mode, use GCMParameterSpec with the provided tag length.
                GCMParameterSpec gcmSpec = new GCMParameterSpec(tagLength, iv);
                cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, gcmSpec);
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fileInputStream.read(buffer)) != -1) {
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
            } else if (isPadding) {
                // For modes that support automatic padding.
                IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);
                cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec);
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                    byte[] encrypted = cipher.update(buffer, 0, bytesRead);
                    if (encrypted != null && encrypted.length > 0) {
                        socket.getOutputStream().write(encrypted);
                    }
                }
                byte[] finalBytes = cipher.doFinal();
                if (finalBytes != null && finalBytes.length > 0) {
                    socket.getOutputStream().write(finalBytes);
                    System.out.printf(Constants.SENT_FILE, infile);
                }
                socket.getOutputStream().flush();
            } else {
                // For noPadding mode (non-GCM), manually handle block alignment.
                IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);
                cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec);
                byte[] buffer = new byte[4096];
                byte[] leftover = new byte[0];
                int bytesRead;
                while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                    // Combine leftover with newly read bytes.
                    byte[] combined = new byte[leftover.length + bytesRead];
                    System.arraycopy(leftover, 0, combined, 0, leftover.length);
                    System.arraycopy(buffer, 0, combined, leftover.length, bytesRead);

                    // Encrypt all full blocks.
                    int fullLen = (combined.length / blockSize) * blockSize;
                    int remainder = combined.length - fullLen;
                    if (fullLen > 0) {
                        byte[] toEncrypt = Arrays.copyOfRange(combined, 0, fullLen);
                        byte[] encrypted = cipher.update(toEncrypt);
                        if (encrypted != null && encrypted.length > 0) {
                            socket.getOutputStream().write(encrypted);
                        }
                    }

                    // Save leftover partial block.
                    leftover = remainder > 0 ? Arrays.copyOfRange(combined, fullLen, combined.length)
                            : new byte[0];
                }

                // If there is any leftover, pad it manually (here with zeros).
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
                    algorithmUpper,
                    key.length
            );
            Main.showUsage(message);
        } catch (NoSuchPaddingException e) {
            Main.showUsage(Constants.INVALID_PADDING_ALGORITHM);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        } catch (InvalidAlgorithmParameterException e) {
            if (!algorithm.equals("AES") && !algorithm.equals("DES")) {
                Main.showUsage(String.format(Constants.INVALID_ALGORITHM_CHOSEN, suite));
            } else {
                System.out.printf("Error: Invalid key when encrypting: Invalid " + algorithm +
                        " key length: " + key.length + " bytes\n");
                System.out.printf("Error sending file: Connection refused\n");
                System.exit(0);
            }
        } catch (BadPaddingException e) {
            throw new RuntimeException(e);
        } catch (IllegalBlockSizeException e) {
            throw new RuntimeException(e);
        }
    }
}